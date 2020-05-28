{ stdenv
, buildGoPackage
, fetchFromGitHub
, fetchpatch
, alsaLib
, dbus
, ddcutil
, dde-api
, deepin
, deepin-desktop-base
, deepin-desktop-schemas
, deepin-gettext-tools
, deepin-wallpapers
, gdk-pixbuf-xlib
, gettext
, glib
, glibc
, go
, go-dbus-factory
, go-gir-generator
, go-lib
, gobject-introspection
, gtk3
, hicolor-icon-theme
, libgudev
, libinput
, libnl
, librsvg
, linux-pam
, lshw
, makeWrapper
, networkmanager
, pkg-config
, pulseaudio
, python3Packages
, tzdata
, wrapGAppsHook
, xkeyboard_config
}:

buildGoPackage rec {
  pname = "dde-daemon";
  version = "5.11.0.33";

  goPackagePath = "pkg.deepin.io/dde/daemon";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0n4gmslyi3sfwa79h3zxlnnwmn84cnmjx8w9j0rvysir45fv3g76";
  };

  patches = [
    # https://github.com/linuxdeepin/dde-daemon/issues/51
    (fetchpatch {
      name = "dde-daemon_5.9.4.2.diff";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/dde-daemon_5.9.4.2.diff?h=packages/deepin-daemon";
      sha256 = "1ld2mb6nxwh4f41fdvlfa6pdb9sg8zcw9z4m03iqp6lrxg152gjg";
    })
  ];

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    deepin-gettext-tools
    deepin.setupHook
    gettext
    gobject-introspection
    makeWrapper
    networkmanager
    networkmanager.dev
    pkg-config
    python3Packages.pygobject3
    python3Packages.python
    wrapGAppsHook
  ];

  buildInputs = [
    alsaLib
    dbus
    ddcutil
    dde-api
    deepin-desktop-base
    deepin-desktop-schemas
    deepin-wallpapers
    gdk-pixbuf-xlib
    glib
    go-dbus-factory
    go-gir-generator
    go-lib
    gtk3
    hicolor-icon-theme
    libgudev
    libinput
    libnl
    librsvg
    linux-pam
    lshw
    pulseaudio
    tzdata
    xkeyboard_config
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    patchShebangs network/nm_generator/gen_nm_consts.py

    fixPath $out /usr/share/dde/data launcher/manager.go dock/dock_manager_init.go
    fixPath $out /usr/share/dde-daemon launcher/manager.go gesture/config.go
    fixPath ${networkmanager.dev} /usr/share/gir-1.0/NM-1.0.gir network/nm_generator/Makefile
    fixPath ${glibc.bin} /usr/bin/getconf systeminfo/utils.go
    fixPath ${deepin-desktop-base} /etc/deepin-version systeminfo/version.go
    fixPath ${deepin-desktop-base} /etc/deepin-version accounts/deepinversion.go
    fixPath ${tzdata} /usr/share/zoneinfo timedate/zoneinfo/zone.go
    fixPath ${dde-api} /usr/lib/deepin-api grub2/modify_manger.go accounts/image_blur.go
    fixPath ${deepin-wallpapers} /usr/share/wallpapers appearance/background/list.go accounts/user.go
    fixPath ${xkeyboard_config} /usr/share/X11/xkb inputdevices/layout_list.go
    fixPath ${dbus} /usr/bin/dbus-send misc/udev-rules/80-deepin-fprintd.rules

    substituteInPlace system/systeminfo/manager.go --replace \"lshw\" \"${lshw}/bin/lshw\"

    # TODO: kwin_no_scale is provided by dde-kwin, but adding it as a
    # dependence causes mutual recursion. For now assumes it can be
    # founded in $PATH:

    substituteInPlace keybinding/utils.go --replace /usr/bin/kwin_no_scale kwin_no_scale

    # TODO: deepin-system-monitor comes from dde-extra

    sed -i -e "s|{DESTDIR}/etc|{DESTDIR}$out/etc|" Makefile
    sed -i -e "s|{DESTDIR}/lib|{DESTDIR}$out/lib|" Makefile
    sed -i -e "s|{DESTDIR}/var|{DESTDIR}$out/var|" Makefile

    find -type f -exec sed -i -e "s,/usr/lib/deepin-daemon,$out/lib/deepin-daemon," {} +

    # This package wants to install polkit local authority files into
    # /var/lib. Nix does not allow a package to install files into /var/lib
    # because it is outside of the Nix store and should contain applications
    # state information (persistent data modified by programs as they
    # run). Polkit looks for them in both /etc/polkit-1 and
    # /var/lib/polkit-1 (with /etc having priority over /var/lib). An
    # work around is to install them to $out/etc and simlnk them to
    # /etc in the deepin module.

    sed -i -e "s,/var/lib/polkit-1,/etc/polkit-1," Makefile
  '';

  buildPhase = ''
    GOPATH="$GOPATH:${go-dbus-factory}/share/go"
    GOPATH="$GOPATH:${go-gir-generator}/share/go"
    GOPATH="$GOPATH:${go-lib}/share/go"
    GOPATH="$GOPATH:${dde-api}/share/go"

    make gen-nm-code \
      PYTHONPATH=${python3Packages.pygobject3}/${python3Packages.python.sitePackages}:$PYTHONPATH \
      -C go/src/${goPackagePath}/network/nm_generator

    make -C go/src/${goPackagePath}
  '';

  installPhase = ''
    make install PREFIX="$out" PAM_MODULE_DIR="$out/lib/security" -C go/src/${goPackagePath}
    remove-references-to -t ${go} $out/lib/deepin-daemon/*
  '';

  postFixup = ''
    # wrapGAppsHook does not work with binaries outside of $out/bin or $out/libexec
    for binary in $out/lib/deepin-daemon/*; do
      if [ -x $binary -a ! -d $binary ]; then
        wrapGApp "$binary"
      fi
    done

    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Daemon for handling Deepin Desktop Environment session settings";
    homepage = "https://github.com/linuxdeepin/dde-daemon";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
