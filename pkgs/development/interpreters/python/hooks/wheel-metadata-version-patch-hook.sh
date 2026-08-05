# Setup hook for patching version metadata of python packages.
# mostly following `python-relax-deps-hook` implementation
# shellcheck shell=bash

echo "Sourcing wheel-metadata-version-patch-hook.sh"

_patchMetadataVersion() {
    local -r metadata_file="$1"

    if [[ ! -f "$metadata_file" ]]; then
        echo "Error: Metadata file not found at '$metadata_file'"
        return 1
    fi

    if grep -q "^Version: $version" "$metadata_file"; then
        echo "Error: The version already matches the derivation's version. Remove this hook"
        return 1
    fi

    if grep -q "^Version:" "$metadata_file"; then
        sed -i -E "s/^(Version:).*/\1 $version/" "$metadata_file"
    else
        echo "Error: No patchable version specification found"
    fi
}

wheelMatadataVersionPatchPhase() {
    pushd dist

    local -r unpack_dir="unpacked"
    local -r metadata_file="$unpack_dir/*/*.dist-info/METADATA"

    # We generally shouldn't have multiple wheel files, but let's be safer here
    for wheel in *".whl"; do

        PYTHONPATH="@wheel@/@pythonSitePackages@:$PYTHONPATH" \
            @pythonInterpreter@ -m wheel unpack --dest "$unpack_dir" "$wheel"
        rm -rf "$wheel"

        # Using no quotes on purpose since we need to expand the glob from `$metadata_file`
        # shellcheck disable=SC2086
        _patchMetadataVersion $metadata_file

        if (("${NIX_DEBUG:-0}" >= 1)); then
            echo "resulting METADATA for '$wheel':"
            # shellcheck disable=SC2086
            cat $metadata_file
        fi

        PYTHONPATH="@wheel@/@pythonSitePackages@:$PYTHONPATH" \
            @pythonInterpreter@ -m wheel pack "$unpack_dir/"*
    done

    # Remove the folder since it will otherwise be in the dist output.
    rm -rf "$unpack_dir"

    popd
}

postBuild+=" wheelMatadataVersionPatchPhase"
