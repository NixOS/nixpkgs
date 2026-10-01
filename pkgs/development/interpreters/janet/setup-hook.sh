addJanetBundlePath() {
    # Janet expects the last element in JANET_PATH to be the *syspath*

    export JANET_PATH="${JANET_PATH:-@out@/lib/janet}"

    if [[ -d "$1/lib/janet" && "${JANET_PATH:+:${JANET_PATH}:}" != *":$1/lib/janet:"* ]]; then
        if [[ "$JANET_PATH" == *:* ]]; then
            export JANET_PATH="${JANET_PATH%:*}:$1/lib/janet:${JANET_PATH##*:}"
        else
            export JANET_PATH="$1/lib/janet:$JANET_PATH"
        fi
    fi
}

addEnvHooks "$targetOffset" addJanetBundlePath
