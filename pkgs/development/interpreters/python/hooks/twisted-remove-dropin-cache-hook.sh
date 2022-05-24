# Setup hook for removing dropin.cache from the plugins folder
echo "Sourcing twisted-remove-dropin-cache-hook.sh"

# dropin.cache files are used to cache information about what plugins are
# present in the directory which contains them. See
# https://twistedmatrix.com/documents/current/core/howto/plugin.html#plugin-caching
# They can lead to collisions in e.g. python3.withPackages environments.

twistedRemoveDropinCachePhase () {
    rm -f $out/@pythonSitePackages@/twisted/plugins/dropin.cache
}

if [ -z "${dontUseTwistedRemoveDropinCache-}" ]; then
    preDistPhases+=" twistedRemoveDropinCachePhase"
fi
