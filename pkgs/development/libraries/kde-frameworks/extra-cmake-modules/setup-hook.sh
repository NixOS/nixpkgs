_ecmSetXdgDirs() {
    addToSearchPath XDG_DATA_DIRS "$1/share"
    addToSearchPath XDG_CONFIG_DIRS "$1/etc/xdg"
}

envHooks+=(_ecmSetXdgDirs)

_ecmConfig() {
    # Because we need to use absolute paths here, we must set *all* the paths.
    cmakeFlags+=" -DKDE_INSTALL_EXECROOTDIR=${!outputBin}"
    cmakeFlags+=" -DKDE_INSTALL_BINDIR=${!outputBin}/bin"
    cmakeFlags+=" -DKDE_INSTALL_SBINDIR=${!outputBin}/sbin"
    cmakeFlags+=" -DKDE_INSTALL_LIBDIR=${!outputLib}/lib"
    cmakeFlags+=" -DKDE_INSTALL_LIBEXECDIR=${!outputBin}/lib/libexec"
    cmakeFlags+=" -DKDE_INSTALL_CMAKEPACKAGEDIR=${!outputDev}/lib/cmake"
    cmakeFlags+=" -DKDE_INSTALL_QTPLUGINDIR=${!outputBin}/lib/qt5/plugins"
    cmakeFlags+=" -DKDE_INSTALL_PLUGINDIR=${!outputBin}/lib/qt5/plugins"
    cmakeFlags+=" -DKDE_INSTALL_QTQUICKIMPORTSDIR=${!outputBin}/lib/qt5/imports"
    cmakeFlags+=" -DKDE_INSTALL_QMLDIR=${!outputBin}/lib/qt5/qml"
    cmakeFlags+=" -DKDE_INSTALL_INCLUDEDIR=${!outputInclude}/include"
    cmakeFlags+=" -DKDE_INSTALL_LOCALSTATEDIR=/var"
    cmakeFlags+=" -DKDE_INSTALL_DATAROOTDIR=${!outputBin}/share"
    cmakeFlags+=" -DKDE_INSTALL_DATADIR=${!outputBin}/share"
    cmakeFlags+=" -DKDE_INSTALL_DOCBUNDLEDIR=${!outputBin}/share/doc/HTML"
    cmakeFlags+=" -DKDE_INSTALL_KCFGDIR=${!outputBin}/share/config.kcfg"
    cmakeFlags+=" -DKDE_INSTALL_KCONFUPDATEDIR=${!outputBin}/share/kconf_update"
    cmakeFlags+=" -DKDE_INSTALL_KSERVICES5DIR=${!outputBin}/share/kservices5"
    cmakeFlags+=" -DKDE_INSTALL_KSERVICETYPES5DIR=${!outputBin}/share/kservicetypes5"
    cmakeFlags+=" -DKDE_INSTALL_KXMLGUI5DIR=${!outputBin}/share/kxmlgui5"
    cmakeFlags+=" -DKDE_INSTALL_KNOTIFY5RCDIR=${!outputBin}/share/knotifications5"
    cmakeFlags+=" -DKDE_INSTALL_ICONDIR=${!outputBin}/share/icons"
    cmakeFlags+=" -DKDE_INSTALL_LOCALEDIR=${!outputBin}/share/locale"
    cmakeFlags+=" -DKDE_INSTALL_SOUNDDIR=${!outputBin}/share/sounds"
    cmakeFlags+=" -DKDE_INSTALL_TEMPLATEDIR=${!outputBin}/share/templates"
    cmakeFlags+=" -DKDE_INSTALL_WALLPAPERDIR=${!outputBin}/share/wallpapers"
    cmakeFlags+=" -DKDE_INSTALL_APPDIR=${!outputBin}/share/applications"
    cmakeFlags+=" -DKDE_INSTALL_DESKTOPDIR=${!outputBin}/share/desktop-directories"
    cmakeFlags+=" -DKDE_INSTALL_MIMEDIR=${!outputBin}/share/mime/packages"
    cmakeFlags+=" -DKDE_INSTALL_METAINFODIR=${!outputBin}/share/appdata"
    cmakeFlags+=" -DKDE_INSTALL_MANDIR=${!outputBin}/share/man"
    cmakeFlags+=" -DKDE_INSTALL_INFODIR=${!outputBin}/share/info"
    cmakeFlags+=" -DKDE_INSTALL_DBUSDIR=${!outputBin}/share/dbus-1"
    cmakeFlags+=" -DKDE_INSTALL_DBUSINTERFACEDIR=${!outputBin}/share/dbus-1/interfaces"
    cmakeFlags+=" -DKDE_INSTALL_DBUSSERVICEDIR=${!outputBin}/share/dbus-1/services"
    cmakeFlags+=" -DKDE_INSTALL_DBUSSYSTEMSERVICEDIR=${!outputBin}/share/dbus-1/system-services"
    cmakeFlags+=" -DKDE_INSTALL_SYSCONFDIR=${!outputBin}/etc"
    cmakeFlags+=" -DKDE_INSTALL_CONFDIR=${!outputBin}/etc/xdg"
    cmakeFlags+=" -DKDE_INSTALL_AUTOSTARTDIR=${!outputBin}/etc/xdg/autostart"
}

preConfigureHooks+=(_ecmConfig)
