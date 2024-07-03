# shellcheck shell=bash

echo "Sourcing log-from-setup-hook"

logFromSetupHookUsage() {
    echo "Usage: <logLevel> <scriptName> <fnName> <message>"
    echo "  logLevel: ERROR, WARNING, INFO, or DEBUG"
    echo "  scriptName: The name of the enclosing script"
    echo "  fnName: The name of the function being called"
    echo "  message: The message to log"
}

# Utility function to log messages with default values for the host and target offsets.
# Expects arguments:
# 1. The level of the message (must be one of ERROR, WARNING, INFO, or DEBUG). DEBUG is only shown if NIX_DEBUG is
#    greater than or equal to 1.
# 2. The name of the enclosing script.
# 3. The name of the function being called.
# 4. The message to log.
logFromSetupHook() {
    if (( $# != 4 )); then
        echo "logFromSetupHook: Expected 4 arguments, got $#"
        logFromSetupHookUsage
        exit 1
    fi

    # Check that the log level is non-empty and valid.
    if [[ -z "${1-}" ]]; then
        echo "logFromSetupHook: Log level is empty"
        logFromSetupHookUsage
        exit 1
    elif [[ ! "${1-}" =~ ^(ERROR|WARNING|INFO|DEBUG)$ ]]; then
        echo "logFromSetupHook: Invalid log level: $1"
        logFromSetupHookUsage
        exit 1
    fi
    local logLevel="${1:?}"

    # Check that the script name is non-empty.
    if [[ -z "${2-}" ]]; then
        echo "logFromSetupHook: Script name is empty"
        logFromSetupHookUsage
        exit 1
    fi
    local scriptName="${2:?}"

    # Check that the function name is non-empty and valid.
    if [[ -z "${3-}" ]]; then
        echo "logFromSetupHook: Function name is empty"
        logFromSetupHookUsage
        exit 1
    fi
    local fnName="${3:?}"

    # Check that the message is non-empty.
    if [[ -z "${4-}" ]]; then
        echo "logFromSetupHook: Message is empty"
        logFromSetupHookUsage
        exit 1
    fi
    local message="${4:?}"

    # Early return if NIX_DEBUG is not set and the log level is DEBUG.
    (( ${NIX_DEBUG:-0} == 0 )) && [[ "$logLevel" == DEBUG ]] && return 0

    # Color handling
    local -A logLevelColorMapping=(
        [ERROR]=31 # Red
        [WARNING]=33 # Yellow
        [INFO]=0 # Default
        [DEBUG]=32 # Green
    )
    local -i logColor="${logLevelColorMapping[$logLevel]:?}"
    local startColor="\e[${logColor}m"
    local endColor="\e[0m"

    printf \
        "${startColor}[%b][%b][%b]: %b${endColor}\n" \
        "$scriptName" \
        "$fnName" \
        "$logLevel" \
        "$message" >&2
}
