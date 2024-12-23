ecmEnvHook() {
    addToSearchPath XDG_DATA_DIRS "$1/share"
    addToSearchPath XDG_CONFIG_DIRS "$1/etc/xdg"
}
addEnvHooks "$targetOffset" ecmEnvHook

ecmPostHook() {
    # Because we need to use absolute paths here, we must set *all* the paths.
    appendToVar cmakeFlags "-DKDE_INSTALL_EXECROOTDIR=${!outputBin}"
    appendToVar cmakeFlags "-DKDE_INSTALL_BINDIR=${!outputBin}/bin"
    appendToVar cmakeFlags "-DKDE_INSTALL_SBINDIR=${!outputBin}/sbin"
    appendToVar cmakeFlags "-DKDE_INSTALL_LIBDIR=${!outputLib}/lib"
    appendToVar cmakeFlags "-DKDE_INSTALL_LIBEXECDIR=${!outputLib}/libexec"
    appendToVar cmakeFlags "-DKDE_INSTALL_CMAKEPACKAGEDIR=${!outputDev}/lib/cmake"
    appendToVar cmakeFlags "-DKDE_INSTALL_INCLUDEDIR=${!outputInclude}/include"
    appendToVar cmakeFlags "-DKDE_INSTALL_LOCALSTATEDIR=/var"
    appendToVar cmakeFlags "-DKDE_INSTALL_DATAROOTDIR=${!outputBin}/share"
    appendToVar cmakeFlags "-DKDE_INSTALL_DATADIR=${!outputBin}/share"
    appendToVar cmakeFlags "-DKDE_INSTALL_DOCBUNDLEDIR=${!outputBin}/share/doc/HTML"
    appendToVar cmakeFlags "-DKDE_INSTALL_KCFGDIR=${!outputBin}/share/config.kcfg"
    appendToVar cmakeFlags "-DKDE_INSTALL_KCONFUPDATEDIR=${!outputBin}/share/kconf_update"
    appendToVar cmakeFlags "-DKDE_INSTALL_KSERVICES5DIR=${!outputBin}/share/kservices5"
    appendToVar cmakeFlags "-DKDE_INSTALL_KSERVICETYPES5DIR=${!outputBin}/share/kservicetypes5"
    appendToVar cmakeFlags "-DKDE_INSTALL_KXMLGUI5DIR=${!outputBin}/share/kxmlgui5"
    appendToVar cmakeFlags "-DKDE_INSTALL_KNOTIFY5RCDIR=${!outputBin}/share/knotifications5"
    appendToVar cmakeFlags "-DKDE_INSTALL_ICONDIR=${!outputBin}/share/icons"
    appendToVar cmakeFlags "-DKDE_INSTALL_LOCALEDIR=${!outputLib}/share/locale"
    appendToVar cmakeFlags "-DKDE_INSTALL_SOUNDDIR=${!outputBin}/share/sounds"
    appendToVar cmakeFlags "-DKDE_INSTALL_TEMPLATEDIR=${!outputBin}/share/templates"
    appendToVar cmakeFlags "-DKDE_INSTALL_WALLPAPERDIR=${!outputBin}/share/wallpapers"
    appendToVar cmakeFlags "-DKDE_INSTALL_APPDIR=${!outputBin}/share/applications"
    appendToVar cmakeFlags "-DKDE_INSTALL_DESKTOPDIR=${!outputBin}/share/desktop-directories"
    appendToVar cmakeFlags "-DKDE_INSTALL_MIMEDIR=${!outputBin}/share/mime/packages"
    appendToVar cmakeFlags "-DKDE_INSTALL_METAINFODIR=${!outputBin}/share/appdata"
    appendToVar cmakeFlags "-DKDE_INSTALL_MANDIR=${!outputBin}/share/man"
    appendToVar cmakeFlags "-DKDE_INSTALL_INFODIR=${!outputBin}/share/info"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSDIR=${!outputBin}/share/dbus-1"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSINTERFACEDIR=${!outputBin}/share/dbus-1/interfaces"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSSERVICEDIR=${!outputBin}/share/dbus-1/services"
    appendToVar cmakeFlags "-DKDE_INSTALL_DBUSSYSTEMSERVICEDIR=${!outputBin}/share/dbus-1/system-services"
    appendToVar cmakeFlags "-DKDE_INSTALL_SYSCONFDIR=${!outputBin}/etc"
    appendToVar cmakeFlags "-DKDE_INSTALL_CONFDIR=${!outputBin}/etc/xdg"
    appendToVar cmakeFlags "-DKDE_INSTALL_AUTOSTARTDIR=${!outputBin}/etc/xdg/autostart"

    if [ "$(uname)" = "Darwin" ]; then
        appendToVar cmakeFlags "-DKDE_INSTALL_BUNDLEDIR=${!outputBin}/Applications/KDE"
    fi

    if [ -n "${qtPluginPrefix-}" ]; then
        appendToVar cmakeFlags "-DKDE_INSTALL_QTPLUGINDIR=${!outputBin}/$qtPluginPrefix"
        appendToVar cmakeFlags "-DKDE_INSTALL_PLUGINDIR=${!outputBin}/$qtPluginPrefix"
    fi

    if [ -n "${qtQmlPrefix-}" ]; then
        appendToVar cmakeFlags "-DKDE_INSTALL_QMLDIR=${!outputBin}/$qtQmlPrefix"
    fi
}
postHooks+=(ecmPostHook)

xdgDataSubdirs=( \
    "config.kcfg" "kconf_update" "kservices5" "kservicetypes5" \
    "kxmlgui5" "knotifications5" "icons" "locale" "sounds" "templates" \
    "wallpapers" "applications" "desktop-directories" "mime" "appdata" "dbus-1" \
)

# ecmHostPathsSeen is an associative array of the paths that have already been
# seen by ecmHostPathHook.
declare -gA ecmHostPathsSeen

ecmHostPathIsNotSeen() {
    if [[ -n "${ecmHostPathsSeen["$1"]:-}" ]]; then
        # The path has been seen before.
        return 1
    else
        # The path has not been seen before.
        # Now it is seen, so record it.
        ecmHostPathsSeen["$1"]=1
        return 0
    fi
}

ecmHostPathHook() {
    ecmHostPathIsNotSeen "$1" || return 0

    local xdgConfigDir="$1/etc/xdg"
    if [ -d "$xdgConfigDir" ]
    then
        qtWrapperArgs+=(--prefix XDG_CONFIG_DIRS : "$xdgConfigDir")
    fi

    for xdgDataSubdir in "${xdgDataSubdirs[@]}"
    do
        if [ -d "$1/share/$xdgDataSubdir" ]
        then
            qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$1/share")
            break
        fi
    done

    local manDir="$1/man"
    if [ -d "$manDir" ]
    then
        qtWrapperArgs+=(--prefix MANPATH : "$manDir")
    fi

    local infoDir="$1/info"
    if [ -d "$infoDir" ]
    then
        qtWrapperArgs+=(--prefix INFOPATH : "$infoDir")
    fi

    if [ -d "$1/dbus-1" ]
    then
        appendToVar propagatedUserEnvPkgs "$1"
    fi
}
addEnvHooks "$targetOffset" ecmHostPathHook
