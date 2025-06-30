# shellcheck shell=bash disable=SC2154
export MSBUILDALWAYSOVERWRITEREADONLYFILES=1
export MSBUILDTERMINALLOGGER=false

declare -Ag _nugetInputs

addNugetInputs() {
    if [[ -d $1/share/nuget ]]; then
        _nugetInputs[$1]=1
    fi
}

addEnvHooks "$targetOffset" addNugetInputs

_linkPackages() {
    local -r src="$1"
    local -r dest="$2"
    local dir
    local x

    (
        shopt -s nullglob
        for x in "$src"/*/*; do
            dir=$dest/$(basename "$(dirname "$x")")
            mkdir -p "$dir"
            ln -s "$x" "$dir"/
        done
    )
}

configureNuget() {
    runHook preConfigureNuGet

    local nugetTemp x

    nugetTemp="$(mktemp -dt nuget.XXXXXX)"
    # trailing slash required here:
    # Microsoft.Managed.Core.targets(236,5): error : SourceRoot paths are required to end with a slash or backslash: '/build/.nuget-temp/packages'
    # also e.g. from avalonia:
    # <EmbeddedResource Include="$(NuGetPackageRoot)sourcelink/1.1.0/tools/pdbstr.exe" />
    export NUGET_PACKAGES=$nugetTemp/packages/
    export NUGET_FALLBACK_PACKAGES=$nugetTemp/fallback/
    nugetSource=$nugetTemp/source
    mkdir -p "${NUGET_PACKAGES%/}" "${NUGET_FALLBACK_PACKAGES%/}" "$nugetSource"

    for x in "${!_nugetInputs[@]}"; do
        if [[ -d $x/share/nuget/packages ]]; then
            _linkPackages "$x/share/nuget/packages" "${NUGET_FALLBACK_PACKAGES%/}"
        fi

        if [[ -d $x/share/nuget/source ]]; then
            _linkPackages "$x/share/nuget/source" "$nugetSource"
        fi
    done

    if [[ -f .config/dotnet-tools.json
        || -f dotnet-tools.json ]]; then
        : ${linkNugetPackages=1}
    fi

    if [[ -z ${keepNugetConfig-} && -f paket.dependencies ]]; then
        sed -i "s:source .*:source $nugetSource:" paket.dependencies
        sed -i "s:remote\:.*:remote\: $nugetSource:" paket.lock

        : ${linkNuGetPackagesAndSources=1}
    fi

    if [[ -n ${linkNuGetPackagesAndSources-} ]]; then
       for x in "${!_nugetInputs[@]}"; do
           if [[ -d $x/share/nuget/source ]]; then
               @lndir@/bin/lndir -silent "$x/share/nuget/packages" "${NUGET_PACKAGES%/}"
               @lndir@/bin/lndir -silent "$x/share/nuget/source" "${NUGET_PACKAGES%/}"
           fi
       done
    elif [[ -n ${linkNugetPackages-} ]]; then
        for x in "${!_nugetInputs[@]}"; do
            if [[ -d $x/share/nuget/packages ]]; then
                _linkPackages "$x/share/nuget/packages" "${NUGET_PACKAGES%/}"
            fi
        done
    fi

    # create a root nuget.config if one doesn't exist
    local rootConfig
    rootConfig=$(find . -maxdepth 1 -iname nuget.config -print -quit)
    if [[ -z $rootConfig ]]; then
        dotnet new nugetconfig
        rootConfig=nuget.config
    fi

    (
        shopt -s nullglob

        local -a xmlConfigArgs=() xmlRootConfigArgs=()

        local -ra xmlSourceConfigArgs=(
            -s /configuration -t elem -n packageSources
            -d '/configuration/packageSources[position() != 1]'
            -s /configuration/packageSources -t elem -n __new
            -i /configuration/packageSources/__new -t attr -n key -v _nix
            -i /configuration/packageSources/__new -t attr -n value -v "$nugetSource"
            -r /configuration/packageSources/__new -v add)

        if [[ -n ${keepNugetConfig-} ]] &&
            ! @xmlstarlet@/bin/xmlstarlet select -t -i "/configuration/packageSources/clear" -nl "$rootConfig" &&
            ! @xmlstarlet@/bin/xmlstarlet select -t -i "/configuration/packageSources/add[@value='https://api.nuget.org/v3/index.json' or @key='nuget.org']" -nl "$rootConfig"; then
            dotnet nuget add source https://api.nuget.org/v3/index.json --name nuget.org --configfile "$rootConfig"
        fi

        if [[ -z ${keepNugetConfig-} ]]; then
            xmlConfigArgs+=(-d '//configuration/*')
            xmlRootConfigArgs+=("${xmlSourceConfigArgs[@]}")
        else
            if [[ -n ${mapNuGetDependencies-} ]]; then
                xmlConfigArgs+=(
                    -s /configuration -t elem -n __tmp
                    # If there's no packageSourceMapping, we need to add * patterns for
                    # all the sources, else they won't be used.
                    -u \$prev -x ../packageSources/add
                    -d '/configuration/__tmp/add/@*[name() != "key"]'
                    -r /configuration/__tmp/add -v packageSource
                    -s /configuration/__tmp/packageSource -t elem -n package
                    -i \$prev -t attr -n pattern -v \*
                    -r /configuration/__tmp -v packageSourceMapping
                    -d '/configuration/packageSourceMapping[position() != 1]'
                    "${xmlSourceConfigArgs[@]}"
                    # add package source mappings from all existing patterns to _nix
                    # this ensures _nix is always considered
                    -s /configuration/packageSourceMapping -t elem -n packageSource
                    -u \$prev -x ../packageSource/package
                    -i \$prev -t attr -n key -v _nix)

                cd "$nugetSource"
                local id
                for id in *; do
                    id=${id,,}
                    xmlConfigArgs+=(
                        # unmap any fully-qualified patterns that exist, so they
                        # can't be used, using a horrific method for
                        # case-insensitivity in xpath1
                        -d "/configuration/packageSourceMapping/packageSource/package[translate(@pattern, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = ${id@Q}]"
                        -s '/configuration/packageSourceMapping/packageSource[@key="_nix"]' -t elem -n package
                        -i \$prev -t attr -n pattern -v "$id")
                done
                cd - > /dev/null
            else
                xmlConfigArgs+=(
                    "${xmlSourceConfigArgs[@]}"
                    # add package source mappings from all existing patterns to _nix
                    # this ensures _nix is always considered
                    -s /configuration/packageSourceMapping -t elem -n packageSource
                    -u \$prev -x '../packageSource/package'
                    -i \$prev -t attr -n key -v _nix
                    # delete empty _nix mapping
                    -d '/configuration/packageSourceMapping/packageSource[@key="_nix" and not(*)]')
            fi
        fi

        # try to stop the global config from having any effect
        if [[ -z ${keepNugetConfig-} || -z ${allowGlobalNuGetConfig-} ]]; then
            local -ar configSections=(
                config
                bindingRedirects
                packageRestore
                solution
                packageSources
                auditSources
                apikeys
                disabledPackageSources
                activePackageSource
                fallbackPackageFolders
                packageSourceMapping
                packageManagement)

            for section in "${configSections[@]}"; do
                xmlRootConfigArgs+=(
                    -s /configuration -t elem -n "$section"
                    # hacky way of ensuring we use existing sections when they exist
                    -d "/configuration/$section[position() != 1]"
                    # hacky way of adding to the start of a possibly empty element
                    -s "/configuration/$section" -t elem -n __unused
                    -i "/configuration/$section/*[1]" -t elem -n clear
                    -d "/configuration/$section/__unused"
                    # delete consecutive clears
                    # these actually cause nuget tools to fail in some cases
                    -d "/configuration/$section/clear[position() = 2 and name() = \"clear\"]")
            done
        fi

        find . \( -iname nuget.config \) -print0 | while IFS= read -rd "" config; do
            local dir isRoot=

            dir=$(dirname "$config")
            [[ $dir != . ]] || isRoot=1

            @xmlstarlet@/bin/xmlstarlet \
                ed --inplace \
                "${xmlConfigArgs[@]}" \
                ${isRoot:+"${xmlRootConfigArgs[@]}"} \
                "$config"
        done
    )

    runHook postConfigureNuGet
}

if [[ -z ${dontConfigureNuget-} ]]; then
    appendToVar preConfigurePhases configureNuget
fi
