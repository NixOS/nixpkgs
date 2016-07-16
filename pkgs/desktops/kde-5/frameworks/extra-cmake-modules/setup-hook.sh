_ecmSetXdgDirs() {
    addToSearchPathOnce XDG_DATA_DIRS "$1/share"
    addToSearchPathOnce XDG_CONFIG_DIRS "$1/etc/xdg"
    addToSearchPathOnce RUNTIME_XDG_CONFIG_DIRS "$1/etc/xdg"
}

_ecmSharePaths=( \
    "appdata" \
    "applications" \
    "config.cfg" \
    "dbus-1" \
    "desktop-directories" \
    "doc" \
    "icons" \
    "info" \
    "kconf_update" \
    "kservices5" \
    "kservicetypes5" \
    "knotifications5" \
    "kxmlgui5" \
    "locale" \
    "man" \
    "mime" \
    "polkit-1" \
    "sounds" \
    "templates" \
    "wallpapers" \
    )

_ecmPropagateNative() {
    for dir in ${_ecmSharePaths[@]}; do
        if [ -d "$1/share/$dir" ]; then
            propagateOnce propagatedNativeBuildInputs "$1"
            if [ -z "$crossConfig" ]; then
                propagateOnce propagatedUserEnvPkgs "$1"
                addToSearchPathOnce RUNTIME_XDG_DATA_DIRS "$1/share"
            fi
            break
        fi
    done
}

envHooks+=(_ecmSetXdgDirs _ecmPropagate)

_ecmPropagate() {
    for dir in ${_ecmSharePaths[@]}; do
        if [ -d "$1/share/$dir" ]; then
            propagateOnce propagatedBuildInputs "$1"
            propagateOnce propagatedUserEnvPkgs "$1"
            addToSearchPathOnce RUNTIME_XDG_DATA_DIRS "$1/share"
            break
        fi
    done
}

crossEnvHooks+=(_ecmPropagate)

_ecmConfig() {
    # Because we need to use absolute paths here, we must set *all* the paths.
    cmakeFlags+=" -DKDE_INSTALL_EXECROOTDIR=${!outputBin}"
    cmakeFlags+=" -DKDE_INSTALL_BINDIR=${!outputBin}/bin"
    cmakeFlags+=" -DKDE_INSTALL_SBINDIR=${!outputBin}/sbin"
    cmakeFlags+=" -DKDE_INSTALL_LIBDIR=${!outputLib}/lib"
    cmakeFlags+=" -DKDE_INSTALL_LIBEXECDIR=${!outputLib}/lib/libexec"
    cmakeFlags+=" -DKDE_INSTALL_CMAKEPACKAGEDIR=${!outputDev}/lib/cmake"
    cmakeFlags+=" -DKDE_INSTALL_QTPLUGINDIR=${!outputLib}/lib/qt5/plugins"
    cmakeFlags+=" -DKDE_INSTALL_PLUGINDIR=${!outputLib}/lib/qt5/plugins"
    cmakeFlags+=" -DKDE_INSTALL_QTQUICKIMPORTSDIR=${!outputLib}/lib/qt5/imports"
    cmakeFlags+=" -DKDE_INSTALL_QMLDIR=${!outputLib}/lib/qt5/qml"
    cmakeFlags+=" -DKDE_INSTALL_INCLUDEDIR=${!outputInclude}/include"
    cmakeFlags+=" -DKDE_INSTALL_LOCALSTATEDIR=/var"
    cmakeFlags+=" -DKDE_INSTALL_DATAROOTDIR=${!outputLib}/share"
    cmakeFlags+=" -DKDE_INSTALL_DATADIR=${!outputLib}/share"
    cmakeFlags+=" -DKDE_INSTALL_DOCBUNDLEDIR=${!outputLib}/share/doc/HTML"
    cmakeFlags+=" -DKDE_INSTALL_KCFGDIR=${!outputLib}/share/config.kcfg"
    cmakeFlags+=" -DKDE_INSTALL_KCONFUPDATEDIR=${!outputLib}/share/kconf_update"
    cmakeFlags+=" -DKDE_INSTALL_KSERVICES5DIR=${!outputLib}/share/kservices5"
    cmakeFlags+=" -DKDE_INSTALL_KSERVICETYPES5DIR=${!outputLib}/share/kservicetypes5"
    cmakeFlags+=" -DKDE_INSTALL_KXMLGUI5DIR=${!outputLib}/share/kxmlgui5"
    cmakeFlags+=" -DKDE_INSTALL_KNOTIFY5RCDIR=${!outputLib}/share/knotifications5"
    cmakeFlags+=" -DKDE_INSTALL_ICONDIR=${!outputLib}/share/icons"
    cmakeFlags+=" -DKDE_INSTALL_LOCALEDIR=${!outputLib}/share/locale"
    cmakeFlags+=" -DKDE_INSTALL_SOUNDDIR=${!outputLib}/share/sounds"
    cmakeFlags+=" -DKDE_INSTALL_TEMPLATEDIR=${!outputLib}/share/templates"
    cmakeFlags+=" -DKDE_INSTALL_WALLPAPERDIR=${!outputLib}/share/wallpapers"
    cmakeFlags+=" -DKDE_INSTALL_APPDIR=${!outputLib}/share/applications"
    cmakeFlags+=" -DKDE_INSTALL_DESKTOPDIR=${!outputLib}/share/desktop-directories"
    cmakeFlags+=" -DKDE_INSTALL_MIMEDIR=${!outputLib}/share/mime/packages"
    cmakeFlags+=" -DKDE_INSTALL_METAINFODIR=${!outputLib}/share/appdata"
    cmakeFlags+=" -DKDE_INSTALL_MANDIR=${!outputLib}/share/man"
    cmakeFlags+=" -DKDE_INSTALL_INFODIR=${!outputLib}/share/info"
    cmakeFlags+=" -DKDE_INSTALL_DBUSDIR=${!outputLib}/share/dbus-1"
    cmakeFlags+=" -DKDE_INSTALL_DBUSINTERFACEDIR=${!outputLib}/share/dbus-1/interfaces"
    cmakeFlags+=" -DKDE_INSTALL_DBUSSERVICEDIR=${!outputLib}/share/dbus-1/services"
    cmakeFlags+=" -DKDE_INSTALL_DBUSSYSTEMSERVICEDIR=${!outputLib}/share/dbus-1/system-services"
    cmakeFlags+=" -DKDE_INSTALL_SYSCONFDIR=${!outputLib}/etc"
    cmakeFlags+=" -DKDE_INSTALL_CONFDIR=${!outputLib}/etc/xdg"
    cmakeFlags+=" -DKDE_INSTALL_AUTOSTARTDIR=${!outputLib}/etc/xdg/autostart"
}

preConfigureHooks+=(_ecmConfig)
