#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=../../../../. -i bash -p curl jq nix gnused

set -euo pipefail

release () {
  local content="$1"
  local version="$2"

  jq -r '.releases[] | select(."release-version" == "'"$version"'")' <<< "$content"
}

release_files () {
  local release="$1"
  local type="$2"

  jq -r '[."'"$type"'".files[] | select(.name | test("^.*.tar.gz$"))]' <<< "$release"
}

release_platform_attr () {
  local release_files="$1"
  local platform="$2"
  local attr="$3"

  jq -r '.[] | select(.rid == "'"$platform"'") | ."'"$attr"'"' <<< "$release_files"
}

platform_sources () {
  local release_files="$1"
  local platforms=( \
    "x86_64-linux   linux-x64" \
    "aarch64-linux  linux-arm64" \
    "x86_64-darwin  osx-x64" \
    "aarch64-darwin osx-arm64" \
  )

  echo "srcs = {"
  for kv in "${platforms[@]}"; do
    local nix_platform=${kv%% *}
    local ms_platform=${kv##* }

    local url=$(release_platform_attr "$release_files" "$ms_platform" url)
    local hash=$(release_platform_attr "$release_files" "$ms_platform" hash)

    [[ -z "$url" || -z "$hash" ]] && continue
    echo "      $nix_platform = {
        url     = \"$url\";
        sha512  = \"$hash\";
      };"
    done
    echo "    };"
}

generate_package_list() {
    local version pkgs nuget_url
    version="$1"
    shift
    pkgs=( "$@" )

    nuget_url="$(curl -f "https://api.nuget.org/v3/index.json" | jq --raw-output '.resources[] | select(."@type" == "PackageBaseAddress/3.0.0")."@id"')"

    for pkg in "${pkgs[@]}"; do
        local url hash
        url="${nuget_url}${pkg,,}/${version,,}/${pkg,,}.${version,,}.nupkg"
        hash="$(nix-prefetch-url "$url")"
        echo "      (fetchNuGet { pname = \"${pkg}\"; version = \"${version}\"; sha256 = \"${hash}\"; })"
    done
}

aspnetcore_packages () {
    local version=$1
    # These packages are implicitly references by the build process,
    # based on the specific project configurations (RIDs, used features, etc.)
    # They are always referenced with the same version as the SDK used for building.
    # Since we lock nuget dependencies, when these packages are included in the generated
    # lock files (deps.nix), every update of SDK required those lock files to be
    # updated to reflect the new versions of these packages - otherwise, the build
    # would fail due to missing dependencies.
    #
    # Moving them to a separate list stored alongside the SDK package definitions,
    # and implictly including them along in buildDotnetModule allows us
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
    local pkgs=( \
      "Microsoft.AspNetCore.App.Ref" \
      "Microsoft.AspNetCore.App.Runtime.linux-arm" \
      "Microsoft.AspNetCore.App.Runtime.linux-arm64" \
      "Microsoft.AspNetCore.App.Runtime.linux-musl-arm" \
      "Microsoft.AspNetCore.App.Runtime.linux-musl-arm64" \
      "Microsoft.AspNetCore.App.Runtime.linux-musl-x64" \
      "Microsoft.AspNetCore.App.Runtime.linux-x64" \
      "Microsoft.AspNetCore.App.Runtime.osx-arm64" \
      "Microsoft.AspNetCore.App.Runtime.osx-x64" \
      "Microsoft.AspNetCore.App.Runtime.win-arm" \
      "Microsoft.AspNetCore.App.Runtime.win-arm64" \
      "Microsoft.AspNetCore.App.Runtime.win-x64" \
      "Microsoft.AspNetCore.App.Runtime.win-x86" \
    )

    generate_package_list "$version" "${pkgs[@]}"
}

sdk_packages () {
    local version=$1
    # These packages are implicitly references by the build process,
    # based on the specific project configurations (RIDs, used features, etc.)
    # They are always referenced with the same version as the SDK used for building.
    # Since we lock nuget dependencies, when these packages are included in the generated
    # lock files (deps.nix), every update of SDK required those lock files to be
    # updated to reflect the new versions of these packages - otherwise, the build
    # would fail due to missing dependencies.
    #
    # Moving them to a separate list stored alongside the SDK package definitions,
    # and implictly including them along in buildDotnetModule allows us
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
    local pkgs=( \
      "Microsoft.NETCore.App.Composite" \
      "Microsoft.NETCore.App.Host.linux-arm" \
      "Microsoft.NETCore.App.Host.linux-arm64" \
      "Microsoft.NETCore.App.Host.linux-musl-arm" \
      "Microsoft.NETCore.App.Host.linux-musl-arm64" \
      "Microsoft.NETCore.App.Host.linux-musl-x64" \
      "Microsoft.NETCore.App.Host.linux-x64" \
      "Microsoft.NETCore.App.Host.osx-arm64" \
      "Microsoft.NETCore.App.Host.osx-x64" \
      "Microsoft.NETCore.App.Host.win-arm" \
      "Microsoft.NETCore.App.Host.win-arm64" \
      "Microsoft.NETCore.App.Host.win-x64" \
      "Microsoft.NETCore.App.Host.win-x86" \
      "Microsoft.NETCore.App.Ref" \
      "Microsoft.NETCore.App.Runtime.linux-arm" \
      "Microsoft.NETCore.App.Runtime.linux-arm64" \
      "Microsoft.NETCore.App.Runtime.linux-musl-arm" \
      "Microsoft.NETCore.App.Runtime.linux-musl-arm64" \
      "Microsoft.NETCore.App.Runtime.linux-musl-x64" \
      "Microsoft.NETCore.App.Runtime.linux-x64" \
      "Microsoft.NETCore.App.Runtime.Mono.linux-arm" \
      "Microsoft.NETCore.App.Runtime.Mono.linux-arm64" \
      "Microsoft.NETCore.App.Runtime.Mono.linux-musl-x64" \
      "Microsoft.NETCore.App.Runtime.Mono.linux-x64" \
      "Microsoft.NETCore.App.Runtime.Mono.osx-arm64" \
      "Microsoft.NETCore.App.Runtime.Mono.osx-x64" \
      "Microsoft.NETCore.App.Runtime.Mono.win-x64" \
      "Microsoft.NETCore.App.Runtime.Mono.win-x86" \
      "Microsoft.NETCore.App.Runtime.osx-arm64" \
      "Microsoft.NETCore.App.Runtime.osx-x64" \
      "Microsoft.NETCore.App.Runtime.win-arm" \
      "Microsoft.NETCore.App.Runtime.win-arm64" \
      "Microsoft.NETCore.App.Runtime.win-x64" \
      "Microsoft.NETCore.App.Runtime.win-x86" \
      "Microsoft.NETCore.DotNetAppHost" \
      "Microsoft.NETCore.DotNetHost" \
      "Microsoft.NETCore.DotNetHostPolicy" \
      "Microsoft.NETCore.DotNetHostResolver" \
      "runtime.linux-arm64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.linux-arm64.Microsoft.NETCore.DotNetHost" \
      "runtime.linux-arm64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.linux-arm64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.linux-arm.Microsoft.NETCore.DotNetAppHost" \
      "runtime.linux-arm.Microsoft.NETCore.DotNetHost" \
      "runtime.linux-arm.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.linux-arm.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHost" \
      "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.linux-musl-arm64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.linux-musl-arm.Microsoft.NETCore.DotNetAppHost" \
      "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHost" \
      "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.linux-musl-arm.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.linux-musl-x64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHost" \
      "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.linux-musl-x64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.linux-x64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.linux-x64.Microsoft.NETCore.DotNetHost" \
      "runtime.linux-x64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.linux-x64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.osx-arm64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.osx-arm64.Microsoft.NETCore.DotNetHost" \
      "runtime.osx-arm64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.osx-arm64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.osx-x64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.osx-x64.Microsoft.NETCore.DotNetHost" \
      "runtime.osx-x64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.osx-x64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.win-arm64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.win-arm64.Microsoft.NETCore.DotNetHost" \
      "runtime.win-arm64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.win-arm64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.win-arm.Microsoft.NETCore.DotNetAppHost" \
      "runtime.win-arm.Microsoft.NETCore.DotNetHost" \
      "runtime.win-arm.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.win-arm.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.win-x64.Microsoft.NETCore.DotNetAppHost" \
      "runtime.win-x64.Microsoft.NETCore.DotNetHost" \
      "runtime.win-x64.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.win-x64.Microsoft.NETCore.DotNetHostResolver" \
      "runtime.win-x86.Microsoft.NETCore.DotNetAppHost" \
      "runtime.win-x86.Microsoft.NETCore.DotNetHost" \
      "runtime.win-x86.Microsoft.NETCore.DotNetHostPolicy" \
      "runtime.win-x86.Microsoft.NETCore.DotNetHostResolver" \
    )

    # Packages that only apply to .NET 7 and up
    if [[ ! ( "$version" =~ ^[1-6]\. ) ]]; then
        # ILCompiler requires nixpkgs#181373 to be fixed to work properly
        pkgs+=( \
          "runtime.linux-arm64.Microsoft.DotNet.ILCompiler" \
          "runtime.linux-musl-arm64.Microsoft.DotNet.ILCompiler" \
          "runtime.linux-musl-x64.Microsoft.DotNet.ILCompiler" \
          "runtime.linux-x64.Microsoft.DotNet.ILCompiler" \
          "runtime.osx-x64.Microsoft.DotNet.ILCompiler" \
          "runtime.win-arm64.Microsoft.DotNet.ILCompiler" \
          "runtime.win-x64.Microsoft.DotNet.ILCompiler" \
        )
    fi

    generate_package_list "$version" "${pkgs[@]}"
}

main () {
  pname=$(basename "$0")
  if [[ ! "$*" =~ ^.*[0-9]{1,}\.[0-9]{1,}.*$ ]]; then
    echo "Usage: $pname [sem-versions]
Get updated dotnet src (platform - url & sha512) expressions for specified versions

Examples:
  $pname 3.1.21 5.0.12    - specific x.y.z versions
  $pname 3.1 5.0 6.0      - latest x.y versions
" >&2
    exit 1
  fi

  for sem_version in "$@"; do
    echo "Generating ./versions/${sem_version}.nix"
    patch_specified=false
    # Check if a patch was specified as an argument.
    # If so, generate file for the specific version.
    # If only x.y version was provided, get the latest patch
    # version of the given x.y version.
    if [[ "$sem_version" =~ ^[0-9]{1,}\.[0-9]{1,}\.[0-9]{1,}$ ]]; then
        patch_specified=true
    elif [[ ! "$sem_version" =~ ^[0-9]{1,}\.[0-9]{1,}$ ]]; then
        continue
    fi

    # Make sure the x.y version is properly passed to .NET release metadata url.
    # Then get the json file and parse it to find the latest patch release.
    major_minor=$(sed 's/^\([0-9]*\.[0-9]*\).*$/\1/' <<< "$sem_version")
    content=$(curl -sL https://dotnetcli.blob.core.windows.net/dotnet/release-metadata/"$major_minor"/releases.json)
    major_minor_patch=$([ "$patch_specified" == true ] && echo "$sem_version" || jq -r '."latest-release"' <<< "$content")

    release_content=$(release "$content" "$major_minor_patch")
    aspnetcore_version=$(jq -r '."aspnetcore-runtime".version' <<< "$release_content")
    runtime_version=$(jq -r '.runtime.version' <<< "$release_content")
    sdk_version=$(jq -r '.sdk.version' <<< "$release_content")

    aspnetcore_files="$(release_files "$release_content" "aspnetcore-runtime")"
    runtime_files="$(release_files "$release_content" "runtime")"
    sdk_files="$(release_files "$release_content" "sdk")"

    major_minor_underscore=${major_minor/./_}
    channel_version=$(jq -r '."channel-version"' <<< "$content")
    support_phase=$(jq -r '."support-phase"' <<< "$content")
    echo "{ buildAspNetCore, buildNetRuntime, buildNetSdk, icu }:

# v$channel_version ($support_phase)
{
  aspnetcore_$major_minor_underscore = buildAspNetCore {
    inherit icu;
    version = \"${aspnetcore_version}\";
    $(platform_sources "$aspnetcore_files")
  };

  runtime_$major_minor_underscore = buildNetRuntime {
    inherit icu;
    version = \"${runtime_version}\";
    $(platform_sources "$runtime_files")
  };

  sdk_$major_minor_underscore = buildNetSdk {
    inherit icu;
    version = \"${sdk_version}\";
    $(platform_sources "$sdk_files")
    packages = { fetchNuGet }: [
$(aspnetcore_packages "${aspnetcore_version}")
$(sdk_packages "${runtime_version}")
    ];
  };
}" > "./versions/${sem_version}.nix"
    echo "Generated ./versions/${sem_version}.nix"
  done
}

main "$@"
