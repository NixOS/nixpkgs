{ lib
, buildGoModule
, fetchFromGitHub
, gettext
, pkg-config
, jq
, wrapGAppsHook3
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
  version = "6.0.15";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-RSfdlLT2v3fM4P8E0mIyZZ8A1MWVIS0N0MDczqq7Y64=";
  };

  vendorHash = "sha256-Y81p3yPQayXbvyUI7N6PvFDO3hSU3SL0AuUKxvZkZNE=";

  postPatch = ''
    substituteInPlace display/manager.go \
      --replace "/bin/bash" "${runtimeShell}"

    substituteInPlace misc/systemd_task/dde-display-task-refresh-brightness.service \
       --replace "/usr/bin/dbus-send" "${dbus}/bin/dbus-send"

    substituteInPlace display/manager.go \
      --replace "/usr/lib/deepin-daemon" "/run/current-system/sw/lib/deepin-daemon"

    substituteInPlace misc/lightdm.conf --replace "/usr" "$out"
  '';

  nativeBuildInputs = [
    gettext
    pkg-config
    jq
    wrapGAppsHook3
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
