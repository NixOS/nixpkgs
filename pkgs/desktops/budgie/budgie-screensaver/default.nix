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
, wrapGAppsHook
, xorg
}:

stdenv.mkDerivation rec {
  pname = "budgie-screensaver";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-N8x9hdbaMDisTbQPJedNO4UMLnCn+Q2hhm4udJZgQlc=";
  };

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    wrapGAppsHook
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

  meta = with lib; {
    description = "A fork of old GNOME Screensaver for purposes of providing an authentication prompt on wake";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-screensaver";
    mainProgram = "budgie-screensaver";
    platforms = platforms.linux;
    maintainers = [ maintainers.federicoschonborn ];
    license = licenses.gpl2Only;
  };
}
