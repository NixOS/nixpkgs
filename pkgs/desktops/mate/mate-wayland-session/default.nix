{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  glib,
  mate-polkit,
  mate-notification-daemon,
  wayfire,
  wayfirePlugins,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mate-wayland-session";
  version = "1.28.3";

  src = fetchFromGitHub {
    owner = "mate-desktop";
    repo = "mate-wayland-session";
    rev = "v${version}";
    hash = "sha256-sUAq2BylsvjYn8Lt+nm4yIfVhzIEefxKZYnhJnuxjs0=";
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
      --replace-fail "cat /usr/bin/blueman-applet" "command -v blueman-applet" \
      --replace-fail "cat /usr/bin/gnome-keyring-daemon" "command -v gnome-keyring-daemon"

    # Ensure wayfire.ini is writable, as this script tries to modify it later.
    substituteInPlace session/mate-wayland.sh \
      --replace-fail "cp /usr/share/doc/wayfire/examples/wayfire.ini" "cp --no-preserve=mode,ownership ${wayfire.src}/wayfire.ini" \
      --replace-fail "/usr/share/doc/wayfire/examples/wayfire.ini" "${wayfire.src}/wayfire.ini" \
      --replace-fail "/usr/lib/x86_64-linux-gnu/wayfire/libfiredecor.so" "${wayfirePlugins.firedecor}/lib/wayfire/libfiredecor.so" \
      --replace-fail "/usr/share/doc/firedecor/firedecor.config" "$out/share/doc/firedecor/firedecor.config"
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
    maintainers = teams.mate.members;
  };
}
