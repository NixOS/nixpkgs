{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, gettext
, pkg-config
, jq
, wrapGAppsHook
, glib
, libgnome-keyring
, gtk3
, alsa-lib
, pulseaudio
, libgudev
, libsecret
, runtimeShell
, dbus
}:

buildGoModule rec {
  pname = "startdde";
  version = "6.0.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-B2B8QlA1Ps/ybVzionngtwDwTLd7H02RKJwcXymGlJM=";
  };

  patches = [
    ./0001-avoid-use-hardcode-path.patch
  ];

  vendorHash = "sha256-5BEOazAygYL1N+CaGAbUwdpHZ1EiHr6yNW27/bXNdZg=";

  postPatch = ''
    substituteInPlace display/manager.go session.go \
      --replace "/bin/bash" "${runtimeShell}"

    substituteInPlace misc/systemd_task/dde-display-task-refresh-brightness.service \
       --replace "/usr/bin/dbus-send" "${dbus}/bin/dbus-send"

    substituteInPlace display/manager.go utils.go session.go \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace misc/lightdm.conf --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    gettext
    pkg-config
    jq
    wrapGAppsHook
    glib
  ];

  buildInputs = [
    libgnome-keyring
    gtk3
    alsa-lib
    pulseaudio
    libgudev
    libsecret
  ];

  buildPhase = ''
    runHook preBuild
    make GO_BUILD_FLAGS="$GOFLAGS"
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    make install DESTDIR="$out" PREFIX="/"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Starter of deepin desktop environment";
    homepage = "https://github.com/linuxdeepin/startdde";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
