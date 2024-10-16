# shellcheck shell=bash

# Setup hook that modifies Python dependencies versions.
#
# Example usage in a derivation:
#
#   { …, python3Packages, … }:
#
#   python3Packages.buildPythonPackage {
#     …
#     # This will relax the dependency restrictions
#     # e.g.: abc>1,<=2 -> abc
#     pythonRelaxDeps = [ "abc" ];
#     # This will relax only the upper bound
#     # e.g.: abc>1,<=2 -> abc>1
#     pythonRelaxDeps = [ "abc" ];
#     pythonRelaxDepsUpperOnly = true;
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
# Examples that this hook needs to support:
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


pythonRelaxDepsHook() {
    pushd dist

    local -r unpack_dir="unpacked"
    local -r metadata_file="$unpack_dir/*/*.dist-info/METADATA"
    local -a hookArgs=()

    if [[ -z "${pythonRelaxDeps:-}" ]] || [[ "$pythonRelaxDeps" == 0 ]]; then
        :
    elif [[ "$pythonRelaxDeps" == 1 ]]; then
        hookArgs+=(--relax-all)
    else
        for dep in $pythonRelaxDeps; do
            hookArgs+=(--relax "$dep")
        done
    fi

    if [[ -z "${pythonRemoveDeps:-}" ]] || [[ "$pythonRemoveDeps" == 0 ]]; then
        :
    elif [[ "$pythonRemoveDeps" == 1 ]]; then
        hookArgs+=(--remove-all)
    else
        for dep in $pythonRemoveDeps; do
            hookArgs+=(--remove "$dep")
        done
    fi

    if [[ "${pythonRelaxDepsUpperOnly:-0}" == 1 ]]; then
        hookArgs+=(--relax-upper-only)
    fi

    # We generally shouldn't have multiple wheel files, but let's be safer here
    for wheel in *".whl"; do

        PYTHONPATH="@wheel@/@pythonSitePackages@:$PYTHONPATH" \
            @pythonInterpreter@ -m wheel unpack --dest "$unpack_dir" "$wheel"
        rm -rf "$wheel"

        @pythonInterpreter@ @hook@ "${hookArgs[@]}" --in-place $metadata_file

        if (("${NIX_DEBUG:-0}" >= 1)); then
            echo "pythonRelaxDepsHook: resulting METADATA for '$wheel':"
            cat $metadata_file
        fi

        PYTHONPATH="@wheel@/@pythonSitePackages@:$PYTHONPATH" \
            @pythonInterpreter@ -m wheel pack "$unpack_dir/"*
    done

    # Remove the folder since it will otherwise be in the dist output.
    rm -rf "$unpack_dir"

    popd
}

postBuild+=" pythonRelaxDepsHook"
