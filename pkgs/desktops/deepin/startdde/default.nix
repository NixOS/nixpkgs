{ stdenv, buildGoPackage, fetchFromGitHub, pkgconfig, alsaLib,
  coreutils, dbus-factory, dde-api, dde-daemon, dde-dock,
  dde-file-manager, dde-polkit-agent, dde-session-ui, deepin,
  deepin-desktop-base, deepin-desktop-schemas, deepin-turbo,
  dde-kwin, glib, gnome3, go, go-dbus-factory, go-gir-generator,
  go-lib, gtk3, jq, kmod, libX11, libXi, libcgroup, pciutils, psmisc,
  pulseaudio, systemd, xorg, wrapGAppsHook }:

buildGoPackage rec {
  name = "${pname}-${version}";
  pname = "startdde";
  version = "5.0.1";

  goPackagePath = "pkg.deepin.io/dde/startdde";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1xydmglydksy7hjlavf5pbfy0s0lndgavh8x3kg2mg7d36mbra43";
  };

  goDeps = ./deps.nix;

  outputs = [ "out" ];

  nativeBuildInputs = [
    pkgconfig
    dbus-factory
    dde-api
    go-dbus-factory
    go-gir-generator
    go-lib
    jq
    wrapGAppsHook
    deepin.setupHook
  ];

  buildInputs = [
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
    libcgroup
    pciutils
    psmisc
    pulseaudio
    systemd
    xorg.xdriinfo
  ];

  postPatch = ''
    searchHardCodedPaths  # debugging

    # Commented lines below indicates a doubt about how to fix the hard coded path

     fixPath $out                    /etc/X11                                  Makefile
    #fixPath ?                       /etc/xdg/autostop                         autostop/autostop.go
     fixPath ${coreutils}            /bin/ls                                   copyfile_test.go
     fixPath $out                    /usr/share/startdde/auto_launch.json      launch_group.go
    #fixPath ?                       /usr/bin/kwin_no_scale                    main.go  # not found on deepin linux and archlinux
     fixPath $out                    /usr/share/startdde/memchecker.json       memchecker/config.go
     fixPath $out                    /usr/bin/startdde                         misc/00deepin-dde-env
     fixPath ${dde-file-manager}     /usr/bin/dde-file-manager                 misc/auto_launch/chinese.json
     fixPath ${deepin-turbo}         /usr/lib/deepin-turbo/booster-dtkwidget   misc/auto_launch/chinese.json
     fixPath ${dde-daemon}           /usr/lib/deepin-daemon/dde-session-daemon misc/auto_launch/chinese.json misc/auto_launch/default.json
     fixPath ${dde-dock}             /usr/bin/dde-dock                         misc/auto_launch/chinese.json misc/auto_launch/default.json
     fixPath ${dde-file-manager}     /usr/bin/dde-desktop                      misc/auto_launch/chinese.json misc/auto_launch/default.json
     fixPath $out                    /usr/bin/startdde                         misc/deepin-session
    #fixPath ?                       /usr/lib/lightdm/config-error-dialog.sh   misc/deepin-session  # provided by lightdm on deepin linux
    #fixPath ?                       /usr/sbin/lightdm-session                 misc/deepin-session  # provided by lightdm on deepin linux
     fixPath ${dde-session-ui}       /usr/bin/dde-lock                         session.go
     fixPath ${dde-session-ui}       /usr/bin/dde-shutdown                     session.go
     fixPath ${dde-session-ui}       /usr/lib/deepin-daemon/dde-osd            session.go
     fixPath ${deepin-desktop-base}  /etc/deepin-version                       session.go
     fixPath ${gnome3.gnome-keyring} /usr/bin/gnome-keyring-daemon             session.go
     fixPath ${pulseaudio}           /usr/bin/pulseaudio                       sound_effect.go
    #fixPath ?                       /usr/lib/UIAppSched.hooks                 startmanager.go  # not found anything about this
     fixPath ${dde-session-ui}       /usr/lib/deepin-daemon/dde-welcome        utils.go
     fixPath ${dde-polkit-agent}     /usr/lib/polkit-1-dde/dde-polkit-agent    watchdog/dde_polkit_agent.go
    #fixPath ?                       /var/log/Xorg.0.log                       wm/driver.go
    #fixPath ?                       /etc/deepin-wm-switcher/config.json       wm/switcher_config.go  # not present on nixos, deepin linux and archlinux

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
    make -C go/src/${goPackagePath}
  '';

  installPhase = ''
    make install PREFIX="$out" -C go/src/${goPackagePath}
    rm -rf $out/share/lightdm  # this is uselesss for NixOS
    remove-references-to -t ${go} $out/bin/* $out/sbin/*
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru = {
    updateScript = deepin.updateScript { inherit name; };
    providedSessions = [ "deepin" ];
  };

  meta = with stdenv.lib; {
    description = "Starter of deepin desktop environment";
    homepage = https://github.com/linuxdeepin/startdde;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
