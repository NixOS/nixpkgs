# shellcheck shell=bash

verifyDesktopItemsGetKey() {
    local key=$1 desktopFile=$2
    @crudini@ --get "$desktopFile" "Desktop Entry" "$key" 2>/dev/null
}

verifyDesktopItemsGetExecutableName() {
    local value=$1
    if [[ "$value" == \"* ]]; then
        printf '%s' "${value:1}" | sed -n 's/".*//p'
    else
        printf '%s' "$value" | awk '{print $1}'
    fi
}

verifyDesktopItemsFindExecutable() {
    local cmd=$1
    [ -n "$cmd" ] || return 0

    if [[ "$cmd" == /* ]]; then
        [ -x "$cmd" ]
    else
        # shellcheck disable=SC2154 # outputBin is provided by stdenv
        [ -x "${!outputBin}/bin/$cmd" ] || [ -x "${!outputBin}/sbin/$cmd" ]
    fi
}

# https://specifications.freedesktop.org/icon-theme/latest/#directory_layout :
#   "The image files must be one of the types: PNG, XPM, or SVG, and the
#   extension must be '.png', '.xpm' or '.svg' (lower case)."
#
# `share/pixmaps` is not part of the Icon Theme Specification, but is
# supported as a legacy fallback by e.g. GTK's icon lookup.
verifyDesktopItemsFindIcon() {
    local icon=$1
    [ -n "$icon" ] || return 0

    if [[ "$icon" == /* ]]; then
        [ -e "$icon" ]
        return
    fi

    # See https://specifications.freedesktop.org/icon-naming/latest/#names
    grep -Fxq "$icon" "@standardIconNames@" && return 0

    local output ext match
    for output in $(getAllOutputNames); do
        for ext in png svg xpm; do
            [ -e "${!output}/share/pixmaps/$icon.$ext" ] && return 0
        done
    done

    shopt -s globstar
    for output in $(getAllOutputNames); do
        for match in "${!output}"/share/icons/**/"$icon".*; do
            case "$match" in
                *.png | *.svg | *.xpm)
                    shopt -u globstar
                    return 0
                    ;;
            esac
        done
    done
    shopt -u globstar

    return 1
}

verifyDesktopItemsIsSkipped() {
    local -n skipItemsRef=$1
    local name=$2 item
    for item in "${skipItemsRef[@]}"; do
        [ "$item" = "$name" ] && return 0
    done
    return 1
}

verifyDesktopItemsHook() {
    runHook preVerifyDesktopItems
    echo "Executing verifyDesktopItemsPhase"

    # shellcheck disable=SC2034 # read via verifyDesktopItemsIsSkipped's nameref
    local -a skipItems=()
    concatTo skipItems verifyDesktopItemsSkip

    local failed=0 count=0 desktopFile key value cmd icon

    for desktopFile in "${!outputBin}"/share/applications/*.desktop; do
        if verifyDesktopItemsIsSkipped skipItems "$(basename "$desktopFile")"; then
            echo "Skipping $desktopFile"
            continue
        fi

        echo "Checking $desktopFile"
        count=$((count + 1))

        if ! @desktopFileValidate@ "$desktopFile"; then
            failed=1
            continue
        fi

        for key in Exec TryExec; do
            value=$(verifyDesktopItemsGetKey "$key" "$desktopFile") || true
            [ -n "$value" ] || continue

            cmd=$(verifyDesktopItemsGetExecutableName "$value")
            if ! verifyDesktopItemsFindExecutable "$cmd"; then
                echo "verifyDesktopItemsHook: $key command '$cmd' referenced in $desktopFile was not found" >&2
                failed=1
            fi
        done

        icon=$(verifyDesktopItemsGetKey Icon "$desktopFile") || true
        if [ -n "$icon" ] && ! verifyDesktopItemsFindIcon "$icon"; then
            echo "verifyDesktopItemsHook: Icon '$icon' referenced in $desktopFile was not found" >&2
            failed=1
        fi
    done

    if [ "$count" -eq 0 ]; then
        echo "verifyDesktopItemsHook: no desktop items found" >&2
    else
        echo "verifyDesktopItemsHook: verified $count desktop items"
    fi

    if [ "$failed" -ne 0 ]; then
        echo "verifyDesktopItemsHook: one or more desktop items failed verification" >&2
        exit 1
    fi

    runHook postVerifyDesktopItems
    echo "Finished verifyDesktopItemsPhase"
}

if [[ -z "${dontVerifyDesktopItems-}" ]]; then
    preInstallCheckHooks+=(verifyDesktopItemsHook)
fi
