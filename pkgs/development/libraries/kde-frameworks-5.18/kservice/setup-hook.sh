_propagateServices() {
    if [ -d "$1/share/kservices5" ]; then
        propagateOnce propagatedUserEnvPkgs "$1"
        addToSearchPathOnce XDG_DATA_DIRS "$1/share"
    fi
}

_propagateServiceTypes() {
    if [ -d "$1/share/kservicetypes5" ]; then
        propagateOnce propagatedUserEnvPkgs "$1"
        addToSearchPathOnce XDG_DATA_DIRS "$1/share"
    fi
}

envHooks+=(_propagateServices _propagateServiceTypes)

propagateOnce propagatedBuildInputs "@out@"
