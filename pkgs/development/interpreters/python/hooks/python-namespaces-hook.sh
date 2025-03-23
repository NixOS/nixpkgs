# Clean up __init__.py's found in namespace directories
# shellcheck shell=bash

echo "Sourcing python-namespaces-hook"

pythonNamespacesHook() {
    echo "Executing pythonNamespacesHook"

    # Python namespaces names are Python identifiers, which must not contain spaces.
    # See https://docs.python.org/3/reference/lexical_analysis.html
    # shellcheck disable=SC2048
    for namespace in ${pythonNamespaces[*]-}; do
        echo "Enforcing PEP420 namespace: ${namespace}"

        # split namespace into segments. "azure.mgmt" -> "azure mgmt"
        IFS='.' read -ra pathSegments <<<"$namespace"
        # shellcheck disable=SC2154
        constructedPath=$out/@pythonSitePackages@

        # Need to remove the __init__.py at each namespace level
        # E.g `azure/__init__.py` and `azure/mgmt/__init__.py`
        # The __pycache__ entry also needs to be removed
        for pathSegment in "${pathSegments[@]}"; do
            constructedPath=${constructedPath}/${pathSegment}
            pathToRemove=${constructedPath}/__init__.py
            pycachePath=${constructedPath}/__pycache__/

            # remove __init__.py
            if [ -f "$pathToRemove" ]; then
                rm -v "$pathToRemove"
            fi

            # remove ${pname}-${version}-${python-interpeter}-nspkg.pth
            #
            # Still need to check that parent directory exists in the
            # event of a "meta-package" package, which will just install
            # other packages, but not produce anything in site-packages
            # besides meta information
            if [[ -d "${constructedPath}/../" ]] && [[ -z "${dontRemovePth-}" ]]; then
                # .pth files are located in the parent directory of a module
                @findutils@/bin/find "${constructedPath}/../" -name '*-nspkg.pth' -exec rm -v "{}" +
            fi

            # remove __pycache__/ entry, can be interpreter specific. E.g. __init__.cpython-38.pyc
            # use null characters to perserve potential whitespace in filepath
            if [ -d "$pycachePath" ]; then
                @findutils@/bin/find "$pycachePath" -name '__init__*' -exec rm -v "{}" +
            fi
        done
    done

    echo "Finished executing pythonNamespacesHook"
}

if [[ -z "${dontUsePythonNamespacesHook-}" ]] && [[ -n "${pythonNamespaces-}" ]]; then
    postFixupHooks+=(pythonNamespacesHook)
fi
