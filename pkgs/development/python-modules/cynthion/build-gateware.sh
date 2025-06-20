echo "Sourcing build-gateware-hook"

_buildGatewareHook() (
    echo "Building gateware"
    # find site-packages
    echo "site_packages" "$out/@pythonSitePackages@"

    BUILD_GATEWARE_MAX_WORKERS=${enableParallelBuilding:+${NIX_BUILD_CORES}} \
      python @buildGatewareScript@ "$out/@pythonSitePackages@/cynthion/assets"
)

postInstallHooks+=(_buildGatewareHook)
