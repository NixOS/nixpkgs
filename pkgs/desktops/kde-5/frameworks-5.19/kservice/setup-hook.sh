addServicePkg() {
    local propagated
    for dir in "share/kservices5" "share/kservicetypes5"; do
        if [[ -d "$1/$dir" ]]; then
            propagated=
            for pkg in $propagatedBuildInputs; do
                if [[ "z$pkg" == "z$1" ]]; then
                    propagated=1
                    break
                fi
            done
            if [[ -z $propagated ]]; then
                propagatedBuildInputs="$propagatedBuildInputs $1"
            fi

            propagated=
            for pkg in $propagatedUserEnvPkgs; do
                if [[ "z$pkg" == "z$1" ]]; then
                    propagated=1
                    break
                fi
            done
            if [[ -z $propagated ]]; then
                propagatedUserEnvPkgs="$propagatedUserEnvPkgs $1"
            fi

            break
        fi
    done
}

envHooks+=(addServicePkg)

local propagated
for pkg in $propagatedBuildInputs; do
    if [[ "z$pkg" == "z@out@" ]]; then
        propagated=1
        break
    fi
done
if [[ -z $propagated ]]; then
    propagatedBuildInputs="$propagatedBuildInputs @out@"
fi
