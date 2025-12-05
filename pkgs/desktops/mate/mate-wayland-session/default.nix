{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  mate-polkit,
  mate-notification-daemon,
  mate-settings-daemon,
  wayfire,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mate-wayland-session";
  version = "1.28.4";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-wayland-session";
    rev = "v${version}";
    hash = "sha256-jcYkiJOo1k0bMP/LkBW+QIrSyoj6qi8zZMTxqmuNQd0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib
  ];

  postPatch = ''
    substituteInPlace session/mate-wayland-components.sh \
      --replace-fail "polkit-mate-authentication-agent-1" "${mate-polkit}/libexec/polkit-mate-authentication-agent-1" \
      --replace-fail "mate-notification-daemon" "${mate-notification-daemon}/libexec/mate-notification-daemon" \
      --replace-fail "mate-settings-daemon" "${mate-settings-daemon}/libexec/mate-settings-daemon" \
      --replace-fail "cat /usr/bin/blueman-applet" "command -v blueman-applet" \
      --replace-fail "cat /usr/bin/gnome-keyring-daemon" "command -v gnome-keyring-daemon"

    substituteInPlace session/mate-wayland.sh \
      --replace-fail "/usr/share/doc/wayfire/examples/wayfire.ini" "${wayfire.src}/wayfire.ini"
  '';

  passthru = {
    providedSessions = [ "MATE" ];
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "Wayland session using Wayfire for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    teams = [ teams.mate ];
  };
}
