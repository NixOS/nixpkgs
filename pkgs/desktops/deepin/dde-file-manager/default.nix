{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, avfs, dde-daemon,
  dde-dock, dde-polkit-agent, dde-qt-dbus-factory, deepin,
  deepin-anything, deepin-desktop-schemas, deepin-gettext-tools,
  deepin-movie-reborn, deepin-shortcut-viewer, deepin-terminal,
  disomaster, dtkcore, dtkwidget, ffmpegthumbnailer, file, glib,
  gnugrep, gsettings-qt, gvfs, jemalloc, kcodecs, libX11, libsecret,
  polkit, polkit-qt, poppler, procps, qmake, qt5integration,
  qtmultimedia, qtsvg, qttools, qtx11extras, runtimeShell, samba,
  shadow, taglib, udisks2-qt5, xdg-user-dirs, xorg, zlib,
  wrapGAppsHook }:

mkDerivation rec {
  pname = "dde-file-manager";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0n2nl09anqdq0n5yn688n385rn81lcpybs0sa8m311k3k9ndkkyr";
  };

  nativeBuildInputs = [
    deepin.setupHook
    qmake
    qttools
    pkgconfig
    deepin-gettext-tools
    wrapGAppsHook
  ];

  buildInputs = [
    avfs
    dde-daemon
    dde-dock
    dde-polkit-agent
    dde-qt-dbus-factory
    deepin-anything
    deepin-desktop-schemas
    deepin-movie-reborn.dev
    deepin-shortcut-viewer
    deepin-terminal
    disomaster
    dtkcore
    dtkwidget
    ffmpegthumbnailer
    file
    glib
    gnugrep
    gsettings-qt
    gvfs
    jemalloc
    kcodecs
    libsecret
    polkit
    polkit-qt
    poppler
    procps
    qt5integration
    qtmultimedia
    qtsvg
    qtx11extras
    samba
    taglib
    udisks2-qt5
    xdg-user-dirs
    xorg.libX11
    xorg.libxcb
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.xorgproto
    zlib
  ];

  patches = [
    ./dde-file-manager.fix-paths.patch
    ./dde-file-manager.fix-mime-cache-paths.patch
    ./dde-file-manager.pixmaps-paths.patch
  ];

  postPatch = ''
    searchHardCodedPaths

    patchShebangs dde-desktop/translate_generation.sh
    patchShebangs dde-desktop/translate_ts2desktop.sh
    patchShebangs dde-file-manager-lib/generate_translations.sh
    patchShebangs dde-file-manager/generate_translations.sh
    patchShebangs dde-file-manager/translate_ts2desktop.sh
    patchShebangs usb-device-formatter/generate_translations.sh
    patchShebangs usb-device-formatter/translate_ts2desktop.sh

    # x-terminal-emulator is a virtual package in Debian systems. The
    # terminal emulator is configured by Debian's alternative system.
    # It is not available on NixOS. Use deepin-terminal instead
    sed -i -e "s,x-terminal-emulator,deepin-terminal," \
      dde-file-manager-lib/shutil/fileutils.cpp

    sed -i -e "s,\$\$\\[QT_INSTALL_LIBS\\],$out/lib," \
       dde-file-manager-lib/dde-file-manager-lib.pro \
       dde-file-thumbnail-tool/common.pri \
       common/common.pri

    sed -i '/^QMAKE_PKGCONFIG_DESTDIR/i QMAKE_PKGCONFIG_PREFIX = $$PREFIX' \
       dde-file-manager-lib/dde-file-manager-lib.pro

    fixPath ${dde-dock} /usr/include/dde-dock \
      dde-dock-plugins/disk-mount/disk-mount.pro

    # treefrog is not available in NixOS, and I am not sure if it is really needed
    #fixPath $ {treefrog-framework} /usr/include/treefrog \
    #  dde-sharefiles/appbase.pri

    fixPath ${deepin-anything} /usr/share/dbus-1/interfaces \
      dde-file-manager-lib/dbusinterface/dbusinterface.pri

    sed -i -e "s,\$\$system(\$\$PKG_CONFIG --variable libdir deepin-anything-server-lib),$out/lib," \
      deepin-anything-server-plugins/dde-anythingmonitor/dde-anythingmonitor.pro

    fixPath ${dde-daemon} /usr/lib/deepin-daemon/desktop-toggle \
      dde-zone/mainwindow.h

    fixPath ${deepin-gettext-tools} /usr/bin/deepin-desktop-ts-convert \
      dde-desktop/translate_desktop2ts.sh \
      dde-desktop/translate_ts2desktop.sh \
      dde-file-manager/translate_desktop2ts.sh \
      dde-file-manager/translate_ts2desktop.sh \
      usb-device-formatter/translate_desktop2ts.sh \
      usb-device-formatter/translate_ts2desktop.sh

    fixPath ${avfs} /usr/bin/mountavfs dde-file-manager-lib/shutil/fileutils.cpp
    fixPath ${avfs} /usr/bin/umountavfs dde-file-manager-lib/shutil/fileutils.cpp

    fixPath ${deepin-terminal} /usr/bin/deepin-terminal \
      dde-file-manager-lib/shutil/fileutils.cpp

    fixPath $out /usr/share/dde-file-manager \
      dde-sharefiles/appbase.pri \
      dde-sharefiles/dde-sharefiles.pro

    fixPath $out /usr/share/usb-device-formatter \
      usb-device-formatter/main.cpp

    fixPath $out /usr/share/applications \
      dde-file-manager/mips/dde-file-manager-autostart.desktop \
      dde-desktop/development.pri

    fixPath $out /usr/bin \
      dbusservices/com.deepin.dde.desktop.service \
      dde-desktop/data/com.deepin.dde.desktop.service \
      dde-desktop/dbus/filedialog/com.deepin.filemanager.filedialog.service \
      dde-desktop/dbus/filemanager1/org.freedesktop.FileManager.service \
      dde-file-manager-daemon/dbusservice/com.deepin.filemanager.daemon.service \
      dde-file-manager-daemon/dbusservice/dde-filemanager-daemon.service \
      dde-file-manager-daemon/dde-file-manager-daemon.pro \
      dde-file-manager-lib/dde-file-manager-lib.pro \
      dde-file-manager-lib/pkexec/com.deepin.pkexec.dde-file-manager.policy \
      dde-file-manager/dde-file-manager-xdg-autostart.desktop \
      dde-file-manager/dde-file-manager.desktop \
      dde-file-manager/dde-file-manager.pro \
      dde-file-manager/mips/dde-file-manager-autostart.desktop \
      dde-file-manager/mips/dde-file-manager.desktop \
      dde-file-manager/pkexec/com.deepin.pkexec.dde-file-manager.policy \
      usb-device-formatter/pkexec/com.deepin.pkexec.usb-device-formatter.policy \
      usb-device-formatter/usb-device-formatter.desktop \
      usb-device-formatter/usb-device-formatter.pro
      fixPath $out /etc \
      dde-file-manager/dde-file-manager.pro \
      dde-file-manager-daemon/dde-file-manager-daemon.pro

    fixPath $out /usr \
      common/common.pri \
      dde-desktop/dbus/filedialog/filedialog.pri \
      dde-desktop/dbus/filemanager1/filemanager1.pri \
      dde-desktop/development.pri \
      dde-dock-plugins/disk-mount/disk-mount.pro \
      dde-file-manager-daemon/dde-file-manager-daemon.pro \
      usb-device-formatter/usb-device-formatter.pro

    sed -i -e "s,xdg-user-dir,${xdg-user-dirs}/bin/xdg-user-dir," \
      dde-file-manager/dde-xdg-user-dirs-update

    sed -i -e "s,Exec=dde-file-manager,Exec=$out/bin/dde-file-manager," \
      dde-file-manager/dde-file-manager.desktop

    sed -i -e "s,Exec=gio,Exec=${glib.bin}/bin/gio," \
      dde-desktop/data/applications/dde-trash.desktop \
      dde-desktop/data/applications/dde-computer.desktop

    sed -i -e "s,/usr/lib/gvfs/gvfsd,${gvfs}/libexec/gvfsd," \
      dde-file-manager-lib/gvfs/networkmanager.cpp

    sed -i -e "s,/usr/sbin/smbd,${samba}/bin/smbd," \
           -e "s,/usr/sbin/groupadd,${shadow}/bin/groupadd," \
           -e "s,/usr/sbin/adduser,${shadow}/bin/adduser," \
      dde-file-manager-daemon/usershare/usersharemanager.cpp

    sed -i -e 's,startDetached("deepin-shortcut-viewer",startDetached("${deepin-shortcut-viewer}/bin/deepin-shortcut-viewer",' \
      dde-file-manager-lib/controllers/appcontroller.cpp

    sed -i -e 's,/bin/bash,${runtimeShell},' \
           -e 's,\<ps\>,${procps}/bin/ps,' \
           -e 's,\<grep\>,${gnugrep}/bin/grep,' \
      utils/utils.cpp \
      dde-file-manager-lib/controllers/fileeventprocessor.cpp

    # The hard coded path in `QString("/etc/xdg/%1/%2")` in
    # dde-file-manager-lib/interfaces/dfmsettings.cpp
    # does not needed a fix because all the standard locations
    # are tried before faling back to /etc/xdg.

    # I do not know yet how to deal with:
    #   dde-file-manager-lib/sw_label/llsdeepinlabellibrary.h:        return "/usr/lib/sw_64-linux-gnu/dde-file-manager/libllsdeeplabel.so";
    #   dde-file-manager-lib/sw_label/filemanagerlibrary.h:        return "/usr/lib/sw_64-linux-gnu/dde-file-manager/libfilemanager.so";
    #   dde-file-manager-lib/sw_label/libinstall.sh:mkdir /usr/lib/sw_64-linux-gnu/dde-file-manager
    #   dde-file-manager-lib/sw_label/libinstall.sh:cp libfilemanager.so libllsdeeplabel.so /usr/lib/sw_64-linux-gnu/dde-file-manager
    # They are not present on my installations of Deepin Linux, Arch Linux and Ubuntu. Can they be ignored?

    # Notes:
    # - As file-roller is looked in the path using QStandardPaths::findExecutable, it is not been added as a dependency.
    # - deepin-qt5config is a dependency exclusive to the Deepin Linux distribution. No other distribution has it, according to repology.
  '';

  qmakeFlags = [
    "QMAKE_CFLAGS_ISYSTEM="

    # Disable ffmpeg
    "CONFIG+=DISABLE_FFMPEG"
  ];

  preBuild = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${zlib}/lib";
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH''${LD_LIBRARY_PATH:+:}${libX11}/lib";
  '';

  dontWrapQtApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
    )
  '';

  postFixup = ''
    # debuging
    unset LD_LIBRARY_PATH
    searchForUnresolvedDLL $out
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "File manager and desktop module for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-file-manager;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
