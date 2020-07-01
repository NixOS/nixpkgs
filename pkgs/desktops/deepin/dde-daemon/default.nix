{ stdenv
, buildGoPackage
, fetchFromGitHub
, fetchpatch
, pkgconfig
, go-dbus-factory
, go-gir-generator
, go-lib
, deepin-gettext-tools
, gettext
, dde-api
, deepin-desktop-schemas
, deepin-wallpapers
, deepin-desktop-base
, alsaLib
, glib
, gtk3
, libgudev
, libinput
, libnl
, librsvg
, linux-pam
, networkmanager
, pulseaudio
, python3
, hicolor-icon-theme
, glibc
, tzdata
, go
, deepin
, makeWrapper
, xkeyboard_config
, wrapGAppsHook
}:

buildGoPackage rec {
  pname = "dde-daemon";
  version = "5.0.0";

  goPackagePath = "pkg.deepin.io/dde/daemon";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "08jri31bvzbaxaq78rpp46ndv0li2dij63hakvd9b9gs786srql1";
  };

  patches = [
    # https://github.com/linuxdeepin/dde-daemon/issues/51
    (fetchpatch {
      url = "https://github.com/jouyouyun/tap-gesture-patches/raw/master/patches/dde-daemon_3.8.0.patch";
      sha256 = "1ampdsp9zlg263flswdw9gj10n7gxh7zi6w6z9jgh29xlai05pvh";
    })
  ];

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkgconfig
    deepin-gettext-tools
    gettext
    networkmanager
    networkmanager.dev
    python3
    makeWrapper
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    go-dbus-factory
    go-gir-generator
    go-lib
    linux-pam

    alsaLib
    dde-api
    deepin-desktop-base
    deepin-desktop-schemas
    deepin-wallpapers
    glib
    libgudev
    gtk3
    hicolor-icon-theme
    libinput
    libnl
    librsvg
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
    fixPath ${deepin-desktop-base} /etc/deepin-version systeminfo/version.go accounts/deepinversion.go
    fixPath ${tzdata} /usr/share/zoneinfo timedate/zoneinfo/zone.go
    fixPath ${dde-api} /usr/lib/deepin-api grub2/modify_manger.go accounts/image_blur.go
    fixPath ${deepin-wallpapers} /usr/share/wallpapers appearance/background/list.go accounts/user.go
    fixPath ${xkeyboard_config} /usr/share/X11/xkb inputdevices/layout_list.go

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
    export PAM_MODULE_DIR="$out/lib/security"
    # compilation of the nm module is failing
    #make -C go/src/${goPackagePath}/network/nm_generator gen-nm-code
    make -C go/src/${goPackagePath}
  '';

  installPhase = ''
    make install PREFIX="$out" -C go/src/${goPackagePath}
    remove-references-to -t ${go} $out/lib/deepin-daemon/*
    searchHardCodedPaths $out
  '';

  postFixup = ''
    # wrapGAppsHook does not work with binaries outside of $out/bin or $out/libexec
    for binary in $out/lib/deepin-daemon/*; do
      wrapGApp "$binary"
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
