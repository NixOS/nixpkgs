#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq nix gnused
# shellcheck shell=bash

set -Eeuo pipefail

rids=({linux-{,musl-}{arm,arm64,x64},osx-{arm64,x64},win-{arm64,x64,x86}})

release () {
    local content="$1"
    local version="$2"

    jq -r '.releases[] | select(."release-version" == "'"$version"'")' <<< "$content"
}

release_files () {
    local release="$1"
    local expr="$2"

    jq -r '[('"$expr"').files[] | select(.name | test("^.*.tar.gz$"))]' <<< "$release"
}

release_platform_attr () {
    local release_files="$1"
    local platform="$2"
    local attr="$3"

    jq -r '.[] | select((.rid == "'"$platform"'") and (.name | contains("composite") | not)) | ."'"$attr"'"' <<< "$release_files"
}

platform_sources () {
    local release_files="$1"

    echo "srcs = {"
    for rid in "${rids[@]}"; do
        local url hash

        url=$(release_platform_attr "$release_files" "$rid" url)
        hash=$(release_platform_attr "$release_files" "$rid" hash)

        [[ -z "$url" || -z "$hash" ]] && continue

        hash=$(nix hash convert --to sri --hash-algo sha512 "$hash")

        echo "      $rid = {
        url = \"$url\";
        hash = \"$hash\";
      };"
    done
    echo "    };"
}

nuget_index="$(curl -fsSL "https://api.nuget.org/v3/index.json")"

get_nuget_resource() {
    jq -r '.resources[] | select(."@type" == "'"$1"'")."@id"' <<<"$nuget_index"
}

nuget_package_base_url="$(get_nuget_resource "PackageBaseAddress/3.0.0")"
nuget_registration_base_url="$(get_nuget_resource "RegistrationsBaseUrl/3.6.0")"

generate_package_list() {
    local version="$1" indent="$2"
    shift 2
    local pkgs=( "$@" ) pkg url hash catalog_url catalog hash_algorithm

    for pkg in "${pkgs[@]}"; do
        url=${nuget_package_base_url}${pkg,,}/${version,,}/${pkg,,}.${version,,}.nupkg

        if hash=$(curl -s --head "$url" -o /dev/null -w '%header{x-ms-meta-sha512}') && [[ -n "$hash" ]]; then
            # Undocumented fast path for nuget.org
            # https://github.com/NuGet/NuGetGallery/issues/9433#issuecomment-1472286080
            hash=$(nix hash convert --to sri --hash-algo sha512 "$hash")
        elif {
            catalog_url=$(curl -sL --compressed "${nuget_registration_base_url}${pkg,,}/${version,,}.json" | jq -r ".catalogEntry") && [[ -n "$catalog_url" ]] &&
            catalog=$(curl -sL "$catalog_url") && [[ -n "$catalog" ]] &&
            hash_algorithm="$(jq -er '.packageHashAlgorithm' <<<"$catalog")"&& [[ -n "$hash_algorithm" ]] &&
            hash=$(jq -er '.packageHash' <<<"$catalog") && [[ -n "$hash" ]]
        }; then
            # Documented but slower path (requires 2 requests)
            hash=$(nix hash convert --to sri --hash-algo "${hash_algorithm,,}" "$hash")
        elif hash=$(nix-prefetch-url "$url" --type sha512); then
            # Fallback to downloading and hashing locally
            echo "Failed to fetch hash from nuget for $url, falling back to downloading locally" >&2
            hash=$(nix hash convert --to sri --hash-algo sha512 "$hash")
        else
            echo "Failed to fetch hash for $url" >&2
            exit 1
        fi

        echo "$indent(fetchNupkg { pname = \"${pkg}\"; version = \"${version}\"; hash = \"${hash}\"; })"
    done
}

versionAtLeast () {
    local cur_version=$1 min_version=$2
    printf "%s\0%s" "$min_version" "$cur_version" | sort -zVC
}

# These packages are implicitly references by the build process,
# based on the specific project configurations (RIDs, used features, etc.)
# They are always referenced with the same version as the SDK used for building.
# Since we lock nuget dependencies, when these packages are included in the generated
# lock files (deps.nix), every update of SDK required those lock files to be
# updated to reflect the new versions of these packages - otherwise, the build
# would fail due to missing dependencies.
#
# Moving them to a separate list stored alongside the SDK package definitions,
# and implicitly including them along in buildDotnetModule allows us
# to make updating .NET SDK packages a lot easier - we now just update
# the versions of these packages in one place, and all packages that
# use buildDotnetModule continue building with the new .NET version without changes.
#
# Keep in mind that there is no canonical list of these implicitly
# referenced packages - this list was created based on looking into
# the deps.nix files of existing packages, and which dependencies required
# updating after a SDK version bump.
#
# Due to this, make sure to check if new SDK versions introduce any new packages.
# This should not happend in minor or bugfix updates, but probably happens
# with every new major .NET release.
aspnetcore_packages () {
    local version=$1
    local pkgs=(
        Microsoft.AspNetCore.App.Ref
    )

    generate_package_list "$version" '    ' "${pkgs[@]}"
}

aspnetcore_target_packages () {
    local version=$1
    local rid=$2
    local pkgs=(
        "Microsoft.AspNetCore.App.Runtime.$rid"
    )

    generate_package_list "$version" '      ' "${pkgs[@]}"
}

netcore_packages () {
    local version=$1
    local pkgs=(
        Microsoft.NETCore.DotNetAppHost
        Microsoft.NETCore.App.Ref
    )

    if ! versionAtLeast "$version" 9; then
        pkgs+=(
            Microsoft.NETCore.DotNetHost
            Microsoft.NETCore.DotNetHostPolicy
            Microsoft.NETCore.DotNetHostResolver
        )
    fi

    if versionAtLeast "$version" 7; then
        pkgs+=(
            Microsoft.DotNet.ILCompiler
        )
    fi

    if versionAtLeast "$version" 8; then
        pkgs+=(
            Microsoft.NET.ILLink.Tasks
        )
    fi

    generate_package_list "$version" '    ' "${pkgs[@]}"
}

netcore_host_packages () {
    local version=$1
    local rid=$2
    local pkgs=(
        "Microsoft.NETCore.App.Crossgen2.$rid"
    )

    local min_ilcompiler=
    case "$rid" in
        linux-musl-arm) ;;
        linux-arm) ;;
        win-x86) ;;
        osx-arm64) min_ilcompiler=8 ;;
        *) min_ilcompiler=7 ;;
    esac

    if [[ -n "$min_ilcompiler" ]] && versionAtLeast "$version" "$min_ilcompiler"; then
        pkgs+=(
            "runtime.$rid.Microsoft.DotNet.ILCompiler"
        )
    fi

    generate_package_list "$version" '      ' "${pkgs[@]}"
}

netcore_target_packages () {
    local version=$1
    local rid=$2
    local pkgs=(
        "Microsoft.NETCore.App.Host.$rid"
        "Microsoft.NETCore.App.Runtime.$rid"
        "runtime.$rid.Microsoft.NETCore.DotNetAppHost"
    )

    if ! versionAtLeast "$version" 9; then
        pkgs+=(
            "runtime.$rid.Microsoft.NETCore.DotNetHost"
            "runtime.$rid.Microsoft.NETCore.DotNetHostPolicy"
            "runtime.$rid.Microsoft.NETCore.DotNetHostResolver"
        )
        case "$rid" in
            linux-musl-arm*) ;;
            win-arm64) ;;
            *) pkgs+=(
                     "Microsoft.NETCore.App.Runtime.Mono.$rid"
                 ) ;;
        esac
    fi

    generate_package_list "$version" '      ' "${pkgs[@]}"
}

usage () {
    echo "Usage: $pname [[--sdk] [-o output] sem-version] ...
Get updated dotnet src (platform - url & sha512) expressions for specified versions

Examples:
  $pname 6.0.14 7.0.201    - specific x.y.z versions
  $pname 6.0 7.0           - latest x.y versions
" >&2
}

update() {
    local -r sem_version=$1 sdk=$2
    local output=$3

    local patch_specified=false
    # Check if a patch was specified as an argument.
    # If so, generate file for the specific version.
    # If only x.y version was provided, get the latest patch
    # version of the given x.y version.
    if [[ "$sem_version" =~ ^[0-9]{1,}\.[0-9]{1,}\.[0-9]{1,} ]]; then
        patch_specified=true
    elif [[ ! "$sem_version" =~ ^[0-9]{1,}\.[0-9]{1,}$ ]]; then
        usage
        return 1
    fi

    : ${output:="$(dirname "${BASH_SOURCE[0]}")"/versions/$sem_version.nix}
    echo "Generating $output"

    # Make sure the x.y version is properly passed to .NET release metadata url.
    # Then get the json file and parse it to find the latest patch release.
    local major_minor content major_minor_patch
    major_minor=$(sed 's/^\([0-9]*\.[0-9]*\).*$/\1/' <<< "$sem_version")
    content=$(curl -fsSL https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/"$major_minor"/releases.json)
    if [[ -n $sdk ]]; then
        major_minor_patch=$(
            jq -r --arg version "$sem_version" '
                .releases[] |
                select(.sdks[].version == $version) |
                ."release-version"' <<< "$content")
    else
        major_minor_patch=$([ "$patch_specified" == true ] && echo "$sem_version" || jq -r '."latest-release"' <<< "$content")
    fi
    local major_minor_underscore=${major_minor/./_}

    local release_content aspnetcore_version runtime_version
    local -a sdk_versions

    release_content=$(release "$content" "$major_minor_patch")
    aspnetcore_version=$(jq -r '."aspnetcore-runtime".version' <<< "$release_content")
    runtime_version=$(jq -r '.runtime.version' <<< "$release_content")

    if [[ -n $sdk ]]; then
        sdk_versions=("$sem_version")
    else
        mapfile -t sdk_versions < <(jq -r '.sdks[] | .version' <<< "$release_content" | sort -rn)
    fi

    # If patch was not specified, check if the package is already the latest version
    # If it is, exit early
    if [ "$patch_specified" == false ] && [ -f "$output" ]; then
        local -a versions
        IFS= readarray -d '' versions < <(
            nix-instantiate --eval --json -E "{ output }: with (import output {
                buildAspNetCore = { ... }: {};
                buildNetSdk = { version, ... }: { inherit version; };
                buildNetRuntime = { version, ... }: { inherit version; };
                fetchNupkg = { ... }: {};
            }); (x: builtins.deepSeq x x) [
                runtime_${major_minor_underscore}.version
                sdk_${major_minor_underscore}.version
            ]" --argstr output "$output" | jq --raw-output0 .[])
        if [[ "${versions[0]}" == "$major_minor_patch" && "${versions[1]}" == "${sdk_versions[0]}" ]]; then
            echo "Nothing to update."
            return
        fi
    fi

    local aspnetcore_files runtime_files
    aspnetcore_files="$(release_files "$release_content" .\"aspnetcore-runtime\")"
    runtime_files="$(release_files "$release_content" .runtime)"

    local channel_version support_phase
    channel_version=$(jq -r '."channel-version"' <<< "$content")
    support_phase=$(jq -r '."support-phase"' <<< "$content")

    local aspnetcore_sources runtime_sources
    aspnetcore_sources="$(platform_sources "$aspnetcore_files")"
    runtime_sources="$(platform_sources "$runtime_files")"

    result=$(mktemp)
    trap "rm -f $result" TERM INT EXIT

    (
        echo "{ buildAspNetCore, buildNetRuntime, buildNetSdk, fetchNupkg }:

# v$channel_version ($support_phase)

let
  commonPackages = ["
        aspnetcore_packages "${aspnetcore_version}"
        netcore_packages "${runtime_version}"
        echo "  ];

  hostPackages = {"
        for rid in "${rids[@]}"; do
            echo "    $rid = ["
            netcore_host_packages "${runtime_version}" "$rid"
            echo "    ];"
        done
        echo "  };

  targetPackages = {"
        for rid in "${rids[@]}"; do
            echo "    $rid = ["
            aspnetcore_target_packages "${aspnetcore_version}" "$rid"
            netcore_target_packages "${runtime_version}" "$rid"
            echo "    ];"
        done
        echo "  };

in rec {
  release_$major_minor_underscore = \"$major_minor_patch\";

  aspnetcore_$major_minor_underscore = buildAspNetCore {
    version = \"${aspnetcore_version}\";
    $aspnetcore_sources
  };

  runtime_$major_minor_underscore = buildNetRuntime {
    version = \"${runtime_version}\";
    $runtime_sources
  };"

        local -A feature_bands
        unset latest_sdk

        for sdk_version in "${sdk_versions[@]}"; do
            local sdk_base_version=${sdk_version%-*}
            local feature_band=${sdk_base_version:0:-2}xx
            # sometimes one release has e.g. both 8.0.202 and 8.0.203
            [[ ! ${feature_bands[$feature_band]+true} ]] || continue
            feature_bands[$feature_band]=$sdk_version
            local sdk_files sdk_sources
            sdk_files="$(release_files "$release_content" ".sdks[] | select(.version == \"$sdk_version\")")"
            sdk_sources="$(platform_sources "$sdk_files")"
            local sdk_attrname=sdk_${feature_band//./_}
            [[ -v latest_sdk ]] || local latest_sdk=$sdk_attrname

            echo "
  $sdk_attrname = buildNetSdk {
    version = \"${sdk_version}\";
    $sdk_sources
    inherit commonPackages hostPackages targetPackages;
    runtime = runtime_$major_minor_underscore;
    aspnetcore = aspnetcore_$major_minor_underscore;
  };"
        done

        if [[ -n $sdk ]]; then
            echo "
  sdk = sdk_$major_minor_underscore;
"
        fi

        echo "
  sdk_$major_minor_underscore = $latest_sdk;
}"
        )> "${result}"

        cp "${result}" "$output"
    echo "Generated $output"
}

main () {
    local pname sdk output
    pname=$(basename "$0")

        sdk=
        output=

        while [ $# -gt 0 ]; do
            case $1 in
                --sdk)
                    shift
                    sdk=1
                    ;;
                -o)
                    shift
                    output=$1
                    shift
                    ;;
                *)
                    update "$1" "$sdk" "$output"
                    shift
                    ;;
            esac
        done
}

main "$@"
