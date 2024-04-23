# shellcheck shell=bash

# Enable shellcheck support for functions in the generic builder's setup.sh
# https://github.com/koalaman/shellcheck/issues/2956
# shellcheck source=../../../stdenv/generic/setup.sh
source /dev/null

setupCudaStubs() {
    # shellcheck source=../../../build-support/setup-hooks/role.bash
    source @roles@
    # See setup-hooks/role.bash
    local role_post
    getHostRole

    local -r stubsDir="@stubs@/lib/stubs"
    local -nr nixLdflagsVar="NIX_LDFLAGS${role_post}"
    local -nr ldLibraryPathVar="LD_LIBRARY_PATH"

    (( NIX_DEBUG >= 1 )) && echo "setupCudaStubs: adding $stubsDir to ${!nixLdflagsVar} and ${!ldLibraryPathVar}" >&2

    for _varName in nixLdflagsVar ldLibraryPathVar; do
        # Get the value of the variable whose name is stored in varName
        local -n var="$_varName"
        # While appendToVar can take care of creating unset variables, it will do so using __structuredAttrs as guidance.
        # This is a problem for us because NIX_LDFLAGS is an environment variable, and we need to export it back to the
        # environment, which we can't do if it's an array.
        # addToSearchPath won't create unset variables, so we need to do it ourselves.
        if [[ ! -v ${!var} ]]; then
            (( NIX_DEBUG >= 1 )) && echo "setupCudaStubs: ${!var} is not set; setting it to empty string" >&2
            declare -gx "${!var}"=""

        # Unfortunately, it's not enough to rely on __structuredAttrs to tell us whether it's an array, as derivations may
        # have forced NIX_LDFLAGS to a string.
        elif [[ "$(declare -p "${!var}" 2> /dev/null)" =~ ^"declare -a" ]]; then
            echo "setupCudaStubs: ${!var} is an array;" \
                " it must be a string to be exported to an environment variable" >&2
            exit 1
        fi

        case "${!var}" in
            "${!nixLdflagsVar}")
                appendToVar "${!var}" "-L$stubsDir"
                ;;
            "${!ldLibraryPathVar}")
                addToSearchPath "${!var}" "$stubsDir"
                ;;
            *)
                echo "setupCudaStubs: ${!var} is neither ${!nixLdflagsVar} nor ${!ldLibraryPathVar};" \
                    " unsure of how to add values to this variable" >&2
                exit 1
                ;;
        esac
        (( NIX_DEBUG >= 1 )) && echo "setupCudaStubs: ${!var} is now $var" >&2
    done

    # The return code of the function is the return code of the last command executed. Since NIX_DEBUG typically isn't
    # set, the return value of the last command is 1 (false), causing the setup hook to abort. We don't want that, so
    # we explicitly return 0.
    return 0
}

guardSetupCudaStubs() {
    # Provide default values
    declare -ig hostOffset=${hostOffset:-0}
    declare -ig targetOffset=${targetOffset:-0}
    declare -ig dontAddExtraLibs=${dontAddExtraLibs:-0}
    # Allow the user to disable the addition of CUDA libraries, specifically
    declare -ig cudaDontAddExtraLibs=${cudaDontAddExtraLibs:-0}
    declare -ig NIX_DEBUG=${NIX_DEBUG:-0}
    local guard="Sourcing"
    # shellcheck disable=SC2155
    local reason=" from @stubs@/nix-support/setup-hook"

    (( hostOffset != 0 || targetOffset != 1 )) && guard=Skipping && reason="$reason (because we're not a build-time dep)"
    (( dontAddExtraLibs == 1 )) && guard=Skipping && reason="$reason (because we've been told not to add extra libs)"
    (( cudaDontAddExtraLibs == 1 )) && guard=Skipping && reason="$reason (because we've been told not to add extra CUDA libs)"

    if (( NIX_DEBUG >= 1 )) ; then
        echo "$guard hostOffset=$hostOffset targetOffset=$targetOffset setupCudaStubs$reason" >&2
    else
        echo "$guard setupCudaStubs$reason" >&2
    fi

    [[ "$guard" = Sourcing ]] || return 0

    setupCudaStubs
}
guardSetupCudaStubs
