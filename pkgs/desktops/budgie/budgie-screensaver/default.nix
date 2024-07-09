{ lib
, stdenv
, fetchFromGitHub
, dbus-glib
, glib
, gnome-desktop
, gtk3
, intltool
, libgnomekbd
, libX11
, linux-pam
, meson
, ninja
, pkg-config
, systemd
, wrapGAppsHook3
, xorg
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-screensaver";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-screensaver";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-N8x9hdbaMDisTbQPJedNO4UMLnCn+Q2hhm4udJZgQlc=";
  };

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    glib
    gnome-desktop
    gtk3
    libgnomekbd
    libX11
    linux-pam
    systemd
    xorg.libXxf86vm
  ];

  env.NIX_CFLAGS_COMPILE = "-D_POSIX_C_SOURCE";

  meta = {
    description = "Fork of old GNOME Screensaver for purposes of providing an authentication prompt on wake";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-screensaver";
    mainProgram = "budgie-screensaver";
    platforms = lib.platforms.linux;
    maintainers = lib.teams.budgie.members;
    license = lib.licenses.gpl2Only;
  };
})
