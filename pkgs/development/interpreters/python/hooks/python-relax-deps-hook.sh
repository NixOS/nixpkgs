# shellcheck shell=bash

# Setup hook that modifies Python dependencies versions.
#
# Example usage in a derivation:
#
#   { …, pythonPackages, … }:
#
#   pythonPackages.buildPythonPackage {
#     …
#     nativeBuildInputs = [ pythonPackages.pythonRelaxDepsHook ];
#
#     # This will relax the dependency restrictions
#     # e.g.: abc>1,<=2 -> abc
#     pythonRelaxDeps = [ "abc" ];
#     # This will relax all dependencies restrictions instead
#     # pythonRelaxDeps = true;
#     # This will remove the dependency
#     # e.g.: cde>1,<=2 -> <nothing>
#     pythonRemoveDeps = [ "cde" ];
#     # This will remove all dependencies from the project
#     # pythonRemoveDeps = true;
#     …
#   }
#
# IMPLEMENTATION NOTES:
#
# The "Requires-Dist" dependency specification format is described in PEP 508.
# Examples that the regular expressions in this hook needs to support:
#
# Requires-Dist: foo
#   -> foo
# Requires-Dist: foo[optional]
#   -> foo[optional]
# Requires-Dist: foo[optional]~=1.2.3
#   -> foo[optional]
# Requires-Dist: foo[optional, xyz] (~=1.2.3)
#   -> foo[optional, xyz]
# Requires-Dist: foo[optional]~=1.2.3 ; os_name = "posix"
#   -> foo[optional] ; os_name = "posix"
#
# Currently unsupported: URL specs (foo @ https://example.com/a.zip).

_pythonRelaxDeps() {
    local -r metadata_file="$1"

    if [[ -z "${pythonRelaxDeps:-}" ]] || [[ "$pythonRelaxDeps" == 0 ]]; then
        return
    elif [[ "$pythonRelaxDeps" == 1 ]]; then
        sed -i "$metadata_file" -r \
            -e 's/(Requires-Dist: [a-zA-Z0-9_.-]+\s*(\[[^]]+\])?)[^;]*(;.*)?/\1\3/'
    else
        for dep in $pythonRelaxDeps; do
            sed -i "$metadata_file" -r \
                -e "s/(Requires-Dist: $dep\s*(\[[^]]+\])?)[^;]*(;.*)?/\1\3/"
        done
    fi
}

_pythonRemoveDeps() {
    local -r metadata_file="$1"

    if [[ -z "${pythonRemoveDeps:-}" ]] || [[ "$pythonRemoveDeps" == 0 ]]; then
        return
    elif [[ "$pythonRemoveDeps" == 1 ]]; then
        sed -i "$metadata_file" \
            -e '/Requires-Dist:.*/d'
    else
        for dep in $pythonRemoveDeps; do
            sed -i "$metadata_file" \
                -e "/Requires-Dist: $dep/d"
        done
    fi

}

pythonRelaxDepsHook() {
    pushd dist

    # See https://peps.python.org/pep-0491/#escaping-and-unicode
    local -r pkg_name="${pname//[^[:alnum:].]/_}-$version"
    local -r unpack_dir="unpacked"
    local -r metadata_file="$unpack_dir/$pkg_name/$pkg_name.dist-info/METADATA"

    # We generally shouldn't have multiple wheel files, but let's be safer here
    for wheel in "$pkg_name"*".whl"; do
        @pythonInterpreter@ -m wheel unpack --dest "$unpack_dir" "$wheel"
        rm -rf "$wheel"

        _pythonRelaxDeps "$metadata_file"
        _pythonRemoveDeps "$metadata_file"

        if (( "${NIX_DEBUG:-0}" >= 1 )); then
            echo "pythonRelaxDepsHook: resulting METADATA for '$wheel':"
            cat "$unpack_dir/$pkg_name/$pkg_name.dist-info/METADATA"
        fi

        @pythonInterpreter@ -m wheel pack "$unpack_dir/$pkg_name"
    done

    # Remove the folder since it will otherwise be in the dist output.
    rm -rf "$unpack_dir"

    popd
}

postBuild+=" pythonRelaxDepsHook"
