addMimePkg() {
    local propagated

    if [[ -d "$1/share/mime" ]]; then
        propagated=
        for pkg in $propagatedBuildInputs; do
            if [[ "z$pkg" == "z$1" ]]; then
                propagated=1
            fi
        done
        if [[ -z $propagated ]]; then
            propagatedBuildInputs="$propagatedBuildInputs $1"
        fi

        propagated=
        for pkg in $propagatedUserEnvPkgs; do
            if [[ "z$pkg" == "z$1" ]]; then
                propagated=1
            fi
        done
        if [[ -z $propagated ]]; then
            propagatedUserEnvPkgs="$propagatedUserEnvPkgs $1"
        fi
    fi
}

envHooks+=(addMimePkg)
