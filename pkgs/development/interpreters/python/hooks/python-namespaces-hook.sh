# Clean up __init__.py's found in namespace directories
echo "Sourcing python-namespaces-hook"

pythonNamespacesHook() {
    echo "Executing pythonNamespacesHook"

    for namespace in ${pythonNamespaces[@]}; do
        echo "Enforcing PEP420 namespace: ${namespace}"

        # split namespace into segments. "azure.mgmt" -> "azure mgmt"
        IFS='.' read -ra pathSegments <<< $namespace
        constructedPath=$out/@pythonSitePackages@

        # Need to remove the __init__.py at each namespace level
        # E.g `azure/__init__.py` and `azure/mgmt/__init__.py`
        # The __pycache__ entry also needs to be removed
        for pathSegment in ${pathSegments[@]}; do
            constructedPath=${constructedPath}/${pathSegment}
            pathToRemove=${constructedPath}/__init__.py
            pycachePath=${constructedPath}/__pycache__/__init__*

            if [ -f "$pathToRemove" ]; then
                echo "Removing $pathToRemove"
                rm "$pathToRemove"
            fi

            if [ -f "$pycachePath" ]; then
                echo "Removing $pycachePath"
                rm "$pycachePath"
            fi
        done
    done

    echo "Finished executing pythonNamespacesHook"
}

if [ -z "${dontUsePythonNamespacesHook-}" -a -n "${pythonNamespaces-}" ]; then
    postFixupHooks+=(pythonNamespacesHook)
fi

