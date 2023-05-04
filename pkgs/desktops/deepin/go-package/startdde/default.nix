{ stdenv
, lib
, fetchFromGitHub
, buildGoPackage
, pkg-config
, go-dbus-factory
, go-gir-generator
, go-lib
, gettext
, dde-api
, libgnome-keyring
, gtk3
, alsa-lib
, libpulseaudio
, libgudev
, libsecret
, jq
, wrapGAppsHook
, runtimeShell
, dde-polkit-agent
}:

buildGoPackage rec {
  pname = "startdde";
  version = "5.10.1";

  goPackagePath = "github.com/linuxdeepin/startdde";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-dbTcYS7dEvT0eP45jKE8WiG9Pm4LU6jvR8hjMQv/yxU=";
  };

  patches = [
    ./0001-avoid-use-hardcode-path.patch
  ];

  postPatch = ''
    substituteInPlace display/manager.go session.go \
      --replace "/bin/bash" "${runtimeShell}"
    substituteInPlace display/manager.go main.go utils.go session.go \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"
    substituteInPlace misc/xsessions/deepin.desktop.in --subst-var-by PREFIX $out
    substituteInPlace watchdog/dde_polkit_agent.go misc/auto_launch/{default.json,chinese.json} \
      --replace "/usr/lib/polkit-1-dde/dde-polkit-agent" "${dde-polkit-agent}/lib/polkit-1-dde/dde-polkit-agent"
    substituteInPlace startmanager.go launch_group.go memchecker/config.go \
      --replace "/usr/share/startdde" "$out/share/startdde"
    substituteInPlace misc/lightdm.conf --replace "/usr" "$out"
  '';

  goDeps = ./deps.nix;

  nativeBuildInputs = [
    gettext
    pkg-config
    jq
    wrapGAppsHook
  ];

  buildInputs = [
    go-dbus-factory
    go-gir-generator
    go-lib
    dde-api
    libgnome-keyring
    gtk3
    alsa-lib
    libpulseaudio
    libgudev
    libsecret
  ];

  buildPhase = ''
    runHook preBuild
    addToSearchPath GOPATH "${go-dbus-factory}/share/gocode"
    addToSearchPath GOPATH "${go-gir-generator}/share/gocode"
    addToSearchPath GOPATH "${go-lib}/share/gocode"
    addToSearchPath GOPATH "${dde-api}/share/gocode"
    make -C go/src/${goPackagePath}
    runHook postBuild
  '';

  installPhase = ''
    make install DESTDIR="$out" PREFIX="/" -C go/src/${goPackagePath}
  '';

  passthru.providedSessions = [ "deepin" ];

  meta = with lib; {
    description = "Starter of deepin desktop environment";
    longDescription = ''
      Startdde is used for launching DDE components and invoking user's
      custom applications which compliant with xdg autostart specification
    '';
    homepage = "https://github.com/linuxdeepin/startdde";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
