# shellcheck shell=bash
appsWrapperArgs=()
qtWrapperArgs=()

# Inherit arguments given in mkDerivation
qtWrapperArgs=( ${qtWrapperArgs-} )

qtHostPathSeen=()

qtUnseenHostPath() {
    for pkg in "${qtHostPathSeen[@]}"
    do
        if [ "${pkg:?}" == "$1" ]
        then
            return 1
        fi
    done

    qtHostPathSeen+=("$1")
    return 0
}

qtHostPathHook() {
    qtUnseenHostPath "$1" || return 0

    local pluginDir="$1/${qtPluginPrefix:?}"
    if [ -d "$pluginDir" ]
    then
        qtWrapperArgs+=(--prefix QT_PLUGIN_PATH : "$pluginDir")
    fi

    local qmlDir="$1/${qtQmlPrefix:?}"
    if [ -d "$qmlDir" ]
    then
        qtWrapperArgs+=(--prefix QML2_IMPORT_PATH : "$qmlDir")
    fi
}
addEnvHooks "$hostOffset" qtHostPathHook

qtOwnPathsHook() {
    local xdgDataDir="${!outputBin}/share"
    if [ -d "$xdgDataDir" ]
    then
        qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$xdgDataDir")
    fi

    local xdgConfigDir="${!outputBin}/etc/xdg"
    if [ -d "$xdgConfigDir" ]
    then
        qtWrapperArgs+=(--prefix XDG_CONFIG_DIRS : "$xdgConfigDir")
    fi

    qtHostPathHook "${!outputBin}"

    # Extend the appsWrapperArgs for wrapAppsHook
    appsWrapperArgs+=qtWrapperArgs
}

preFixupPhases+=" qtOwnPathsHook"
