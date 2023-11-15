# Setup hook ensuring pytest_nixpkgs_network_xfail runs during pytestCheckPhase
echo "Sourcing pytest-check-network-xfail-hook"

if [ -z "${dontUsePytestCheck-}" ] && [ -z "${installCheckPhase-}" ]; then
    echo "Using pytestCheckXfailHook"
    pytestFlagsArray+=(-p nixpkgs_xfail_hook)
fi
