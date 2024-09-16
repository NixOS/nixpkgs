# shellcheck shell=bash disable=SC2154

_createNugetSourceInOutput() {
    local package version id dir nupkg content
    local -a nuspec
    shopt -s nullglob

    for package in "$prefix"/share/nuget/packages/*/*; do
        version=$(basename "$package")
        id=$(basename "$(dirname "$package")")
        dir="$prefix/share/nuget/source/$id/$version"
        nupkg=$dir/$id.$version.nupkg
        nuspec=("$package"/*.nuspec)

        if [[ -n ${createInstallableNugetSource-} ]]; then
            content=.
        else
            content=$(basename "${nuspec[0]}")
        fi

        mkdir -p "$dir"
        cp "${nuspec[0]}" "$dir/$id.nuspec"
        (cd "$package" && @zip@/bin/zip -rq0 "$nupkg" "$content")
        @stripNondeterminism@/bin/strip-nondeterminism --type zip "$nupkg"
        touch "$nupkg".sha512
    done
}

createNugetSource() {
    local output
    for output in $(getAllOutputNames); do
        prefix="${!output}" _createNugetSourceInOutput
    done
}

if [[ -z ${dontCreateNugetSource-} ]]; then
    postFixupHooks+=(createNugetSource)
fi
