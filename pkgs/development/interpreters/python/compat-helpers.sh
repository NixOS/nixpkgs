# Helper Bash functions to build compatibility layers.
# shellcheck shell=bash

# shellcheck source=pkgs/stdenv/generic/setup.sh
source /dev/null

# Like concatTo from pkgs/stdenv/generic/setup.sh,
# but Bash-expand the source content if the source is not a Bash array.
expandStringAndConcatTo() {
    local targetName="$1"
    shift
    for sourceName in "$@"; do
        local -a flagsArray=()
        if [[ -v "$sourceName" ]]; then
            local -n sourceRef="$sourceName"
            if [[ "$(declare -p "$sourceName")" =~ "^declare -a" ]]; then
                flagsArray=("${sourceRef[@]}")
            else
                # Bash-evaluate only when the sourceRef is not a Bash array.
                local -a "flagsArray=($sourceRef)"
            fi
            unset -n sourceRef
        fi
        concatTo "$targetName" flagsArray
        unset flagsArray
    done
}

# Convert the given attribute variable to a globally-declared Bash array.
convertToArray() {
    local varName="$1"
    local -n varRef="$varName"
    local varText="${varRef[*]-}"
    unset "$varName"
    declare -ag "$varName"
    # shellcheck disable=SC2229
    read -ar "$varName" <<<"$varText"
}

# Like convertToArray,
# but Bash-expand the content of the variable before conversion.
expandStringAndConvertToArray() {
    local varName="$1"
    local -n varRef="$varName"
    local varText="${varRef[*]-}"
    unset -n varRef
    unset "$varName"
    declare -ag "$varName=($varText)"
}
