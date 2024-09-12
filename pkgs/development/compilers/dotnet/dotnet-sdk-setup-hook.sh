# shellcheck shell=bash disable=SC2154
export MSBUILDALWAYSOVERWRITEREADONLYFILES=1
export MSBUILDTERMINALLOGGER=false

declare -Ag _nugetInputs

addNugetInputs() {
    if [[ -d "$1/share/nuget" ]]; then
        _nugetInputs[$1]=1
    fi
}

addEnvHooks "$targetOffset" addNugetInputs

_linkPackages() {
    local -r src="$1"
    local -r dest="$2"
    local dir
    local x

    for x in "$src"/*/*; do
        dir=$dest/$(basename "$(dirname "$x")")
        mkdir -p "$dir"
        ln -s "$x" "$dir"/
    done
}

createNugetDirs() {
    nugetTemp=$PWD/.nuget-temp
    export NUGET_PACKAGES=$nugetTemp/packages
    export NUGET_FALLBACK_PACKAGES=$nugetTemp/fallback
    nugetSource=$nugetTemp/source
    mkdir -p "$NUGET_PACKAGES" "$NUGET_FALLBACK_PACKAGES" "$nugetSource"

    dotnet new nugetconfig
    if [[ -z ${keepNugetConfig-} ]]; then
        dotnet nuget disable source nuget
    fi

    dotnet nuget add source "$nugetSource" -n _nix
}

configureNuget() {
    local x

    for x in "${!_nugetInputs[@]}"; do
        if [[ -d $x/share/nuget/packages ]]; then
            _linkPackages "$x/share/nuget/packages" "$NUGET_FALLBACK_PACKAGES"
        fi

        if [[ -d $x/share/nuget/source ]]; then
            _linkPackages "$x/share/nuget/source" "$nugetSource"
        fi
    done

    if [[ -n "${linkNugetPackages-}"
        || -f .config/dotnet-tools.json
        || -f dotnet-tools.json
        || -f paket.dependencies ]]; then
        for x in "${!_nugetInputs[@]}"; do
            if [[ -d $x/share/nuget/packages ]]; then
                @lndir@/bin/lndir -silent "$x/share/nuget/packages" "$NUGET_PACKAGES"
            fi
        done
    fi

    if [[ -z ${keepNugetConfig-} && -f paket.dependencies ]]; then
       sed -i "s:source .*:source $nugetSource:" paket.dependencies
       sed -i "s:remote\:.*:remote\: $nugetSource:" paket.lock

       for x in "${!_nugetInputs[@]}"; do
           if [[ -d $x/share/nuget/source ]]; then
               @lndir@/bin/lndir -silent "$x/share/nuget/source" "$NUGET_PACKAGES"
           fi
       done
    fi
}

if [[ -z ${dontConfigureNuget-} ]]; then
    prePhases+=(createNugetDirs)
    preConfigurePhases+=(configureNuget)
fi
