{ stdenv, fetchFromGitHub, fetchpatch, pkgconfig, qmake, qttools,
  qtmultimedia, qtx11extras, gnome3, gsettings-qt, dtkcore, dtkwidget,
  deepin-movie-reborn, jemalloc, ffmpegthumbnailer, poppler, taglib,
  libsecret, kcodecs, deepin-anything, deepin-gettext-tools,
  dde-polkit-agent, dde-dock, deepin, qt5integration, gtk2, qtsvg,
  file, avfs, polkit, polkit-qt, deepin-shortcut-viewer,
  xdg-user-dirs, dde-qt-dbus-factory, deepin-terminal,
  gst-plugins-good, mpv, zlib, libX11, gvfs, glib, xorg, dde-daemon,
  autoPatchelfHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-file-manager";
  version = "4.7.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "186n7m9sy04vzg2igs8wsbzvfw7nqv26rsnwn3aqiysxl2zlxk8y";
  };

  nativeBuildInputs = [
    qmake                   # build
    qttools                 # build
    pkgconfig               # build
    deepin-gettext-tools    # build
    dde-dock                # build
    autoPatchelfHook
    deepin.setupHook
  ];

  buildInputs = [
    avfs                   # recommended
    dde-polkit-agent
    dde-qt-dbus-factory    # build arch ?
    #deepin-anything        # build run [amd64 i386]
    deepin-movie-reborn      # build arch
    #deepin-shortcut-viewer   # arch fedora ?
    deepin-terminal          # arch fedora ?
    dtkcore
    dtkcore
    dtkwidget             # build
    ffmpegthumbnailer     # build
    file                  # arch fedora ?
    #gnome3.file-roller    # arch fedora ?
    gnome3.libsecret      # build
    gsettings-qt          # build
    #gst-plugins-good      # arch fedora ?
    jemalloc              # build
    kcodecs               # build arch ?
    #mpv                   # arch ?
    polkit                # build fedora
    polkit-qt             # build
    poppler               # build
    qt5integration        # recommended
    qtmultimedia          # build
    qtsvg                 # build
    qtx11extras           # build
    taglib                # build fedora ?
    zlib                  # run
    #xdg-user-dirs         # arch fedora ?
    file                  # build arch fedora
    ###!deepin-qt5config      # build

    #libuchardet          # fedora ?
    glib.dev              # build ?
    glib.bin              # provides bin/gio, needed at runtime
    xorg.libX11           # build ?
    xorg.xorgproto        # build ?
    xorg.libxcb           # build ?
    xorg.xcbutilwm        # build ?
    xorg.xcbutil          # build fedora ?

    # run command by QProcess
    #deepin-desktop       # fedora
    gvfs # gvfs-client    # fedora ✓
    #samba                # fedora
    #deepin-manual        # arch:optdepends
    dde-daemon
  ];

  runtimeDependencies = [ zlib xorg.libX11 ];

  postPatch = ''
    searchHardCodedPaths

    patchShebangs .

    # x-terminal-emulator is a virtual package in Debian systems. The
    # terminal emulator is configured by Debian's alternative system.
    # It is not available on NixOS. Use deepin-terminal instead
    sed -i -e "s,x-terminal-emulator,deepin-terminal," dde-file-manager-lib/shutil/fileutils.cpp

    sed -i -e "s,\$\$\\[QT_INSTALL_LIBS\\],$out/lib," \
       dde-file-manager-lib/dde-file-manager-lib.pro \
       dde-file-thumbnail-tool/common.pri \
       common/common.pri

    fixPath ${dde-dock} /usr/include/dde-dock \
      dde-dock-plugins/disk-mount/disk-mount.pro

    # treefrog is not available in NixOS, and I am not sure it is really needed  
    #fixPath $${treefrog-framework} /usr/include/treefrog \
    #  dde-sharefiles/appbase.pri

    # deepin-anything is disabled for now
    #fixPath ${deepin-anything} /usr/include/deepin-anything \
    #  dde-file-manager-lib/quick_search/quicksearch.pri

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

    fixPath ${deepin-terminal} /usr/bin/deepin-terminal dde-file-manager-lib/shutil/fileutils.cpp

    fixPath $out /usr/share/dde-file-manager \
      dde-sharefiles/appbase.pri \
      dde-sharefiles/dde-sharefiles.pro

    fixPath $out /usr/share/usb-device-formatter \
      usb-device-formatter/main.cpp

    fixPath $out /usr/share/applications \
      dde-file-manager/mips/dde-file-manager-autostart.desktop \
      dde-desktop/development.pri

    # Not sure on how to fix /usr/share/applications in:
    # dde-file-manager-lib/shutil/fileutils.cpp
    # dde-file-manager-lib/shutil/mimesappsmanager.cpp

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

    # I do not know yet how to fix the ocurrence of QString("/etc/xdg/%1/%2") in 
    # dde-file-manager-lib/interfaces/dfmsettings.cpp

    # I do not know yet how to deal with:
    # dde-file-manager-lib/sw_label/llsdeepinlabellibrary.h:        return "/usr/lib/sw_64-linux-gnu/dde-file-manager/libllsdeeplabel.so";
    # dde-file-manager-lib/sw_label/filemanagerlibrary.h:        return "/usr/lib/sw_64-linux-gnu/dde-file-manager/libfilemanager.so";
    # dde-file-manager-lib/sw_label/libinstall.sh:mkdir /usr/lib/sw_64-linux-gnu/dde-file-manager
    # dde-file-manager-lib/sw_label/libinstall.sh:cp libfilemanager.so libllsdeeplabel.so /usr/lib/sw_64-linux-gnu/dde-file-manager

    # gio is used without an absolute path in share/applications/dde-computer.desktop and /alt/nixpkgs/result/share/applications/dde-trash.desktop

    sed -i -e "s,/usr/lib/gvfs/gvfsd,${gvfs}/libexec/gvfsd," dde-file-manager-lib/gvfs/networkmanager.cpp
  '';

  qmakeFlags = [
    "QMAKE_CFLAGS_ISYSTEM="

    # Disable ffmpeg
    "CONFIG+=DISABLE_FFMPEG"

    # Disable deepin-anything module, a kernel module for vfs_change
    # monitoring to provide fast file indexing feature
    "CONFIG+=DISABLE_ANYTHING"
  ];

  preBuild = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${zlib}/lib";
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libX11}/lib";
  '';

  postFixup = ''
    # debuging
    unset LD_LIBRARY_PATH
    searchForUnresolvedDLL $out
  '';

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "File manager and desktop module for Deepin Desktop Environment";
    homepage = https://github.com/linuxdeepin/dde-file-manager;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
