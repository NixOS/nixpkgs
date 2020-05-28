{ stdenv
, buildGoPackage
, fetchFromGitHub
, pkg-config
, alsaLib
, coreutils
, dde-api
, dde-daemon
, dde-dock
, dde-file-manager
, dde-polkit-agent
, dde-session-ui
, deepin
, deepin-desktop-base
, deepin-desktop-schemas
, deepin-turbo
, dde-kwin
, glib
, gnome3
, go
, go-dbus-factory
, go-gir-generator
, go-lib
, gtk3
, jq
, kmod
, libX11
, libXi
, libgudev
, libpulseaudio
, libcgroup
, pciutils
, psmisc
, systemd
, xorg
, wrapGAppsHook
}:

buildGoPackage rec {
  pname = "startdde";
  version = "5.5.0.13";

  goPackagePath = "pkg.deepin.io/dde/startdde";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "05717npmgzhrylq5v6s5rpnj4n6lyryn15s1kygcmy834qg0j3jz";
  };

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    pkg-config
    jq
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
    dde-api
    go-dbus-factory
    go-gir-generator
    go-lib
    alsaLib
    dde-daemon
    dde-dock
    dde-file-manager
    dde-kwin
    dde-polkit-agent
    dde-session-ui
    deepin-desktop-schemas
    deepin-turbo
    glib
    gnome3.dconf
    gnome3.gnome-keyring
    gnome3.libgnome-keyring
    gtk3
    kmod
    libX11
    libXi
    libgudev
    libpulseaudio
    libcgroup
    pciutils
    psmisc
    systemd
    xorg.xdriinfo
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    # Commented lines below indicates a doubt about how to fix the hard coded path

     fixPath $out                    /etc/X11                                  Makefile
     fixPath $out                    /etc/profile.d                            Makefile
    #fixPath ?                       /etc/xdg/autostop                         autostop/autostop.go
     fixPath ${coreutils}            /bin/ls                                   copyfile_test.go
     fixPath $out                    /usr/share/startdde/auto_launch.json      launch_group.go
     fixPath ${dde-kwin}             /usr/bin/kwin_no_scale                    main.go
     fixPath $out                    /usr/share/startdde/memchecker.json       memchecker/config.go
     fixPath $out                    /usr/bin/startdde                         misc/Xsession.d/00deepin-dde-env
     fixPath ${dde-file-manager}     /usr/bin/dde-file-manager                 misc/auto_launch/chinese.json
     fixPath ${deepin-turbo}         /usr/lib/deepin-turbo/booster-dtkwidget   misc/auto_launch/chinese.json
     fixPath ${dde-daemon}           /usr/lib/deepin-daemon/dde-session-daemon misc/auto_launch/chinese.json misc/auto_launch/default.json
     fixPath ${dde-dock}             /usr/bin/dde-dock                         misc/auto_launch/chinese.json misc/auto_launch/default.json
     fixPath ${dde-file-manager}     /usr/bin/dde-desktop                      misc/auto_launch/chinese.json misc/auto_launch/default.json
     fixPath $out                    /usr/sbin/deepin-fix-xauthority-perm      misc/lightdm.conf
     fixPath ${dde-session-ui}       /usr/bin/dde-lock                         session.go
     fixPath ${dde-session-ui}       /usr/bin/dde-shutdown                     session.go
     fixPath ${dde-session-ui}       /usr/lib/deepin-daemon/dde-osd            session.go
     fixPath ${deepin-desktop-base}  /etc/deepin-version                       session.go
     fixPath ${gnome3.gnome-keyring} /usr/bin/gnome-keyring-daemon             session.go
    #fixPath ?                       /usr/lib/UIAppSched.hooks                 startmanager.go  # found nothing about this
     fixPath ${dde-session-ui}       /usr/lib/deepin-daemon/dde-welcome        utils.go
     fixPath ${dde-polkit-agent}     /usr/lib/polkit-1-dde/dde-polkit-agent    watchdog/dde_polkit_agent.go

    substituteInPlace session.go           --replace '"kwin_no_scale"' '"${dde-kwin}/bin/kwin_no_scale"'
    substituteInPlace watchdog/dde_kwin.go --replace '"kwin_no_scale"' '"${dde-kwin}/bin/kwin_no_scale"'

    substituteInPlace wm/driver.go      --replace '/sbin/lsmod'                   "${kmod}/bin/lsmod"

    substituteInPlace session.go        --replace 'LookPath("cgexec"'             'LookPath("${libcgroup}/bin/cgexec"'
    substituteInPlace vm.go             --replace 'Command("dde-wm-chooser"'      'Command("${dde-session-ui}/bin/dde-wm-chooser"'
    substituteInPlace vm.go             --replace 'Command("systemd-detect-virt"' 'Command("${systemd}/bin/systemd-detect-virt"'
    substituteInPlace wm/card_info.go   --replace 'Command("lspci"'               'Command("${pciutils}/bin/lspci"'
    substituteInPlace wm/driver.go      --replace 'Command("lspci"'               'Command("${pciutils}/bin/lspci"'
    substituteInPlace wm/driver.go      --replace 'Command("xdriinfo"'            'Command("${xorg.xdriinfo}/bin/xdriinfo"'
    substituteInPlace wm/platform.go    --replace 'Command("gsettings"'           'Command("${glib}/bin/gsettings"'
    substituteInPlace wm/platform.go    --replace 'Command("uname"'               'Command("${coreutils}/bin/uname"'
    substituteInPlace wm/switcher.go    --replace 'Command("killall"'             'Command("${psmisc}/bin/killall"'
  '';

  buildPhase = ''
    GOPATH="$GOPATH:${go-dbus-factory}/share/go"
    GOPATH="$GOPATH:${go-gir-generator}/share/go"
    GOPATH="$GOPATH:${go-lib}/share/go"
    GOPATH="$GOPATH:${dde-api}/share/go"

    make -C go/src/${goPackagePath}
  '';

  installPhase = ''
    make install PREFIX="$out" -C go/src/${goPackagePath}
    rm -rf $out/share/lightdm  # this is uselesss for NixOS
    remove-references-to -t ${go} $out/bin/* $out/sbin/* $out/lib/deepin-daemon/*
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru = {
    updateScript = deepin.updateScript { inherit pname version src; };
    providedSessions = [ "deepin" ];
  };

  meta = with stdenv.lib; {
    description = "Starter of deepin desktop environment";
    homepage = "https://github.com/linuxdeepin/startdde";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
