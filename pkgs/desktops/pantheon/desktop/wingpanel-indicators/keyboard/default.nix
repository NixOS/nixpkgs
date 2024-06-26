{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  meson,
  ninja,
  substituteAll,
  vala,
  gtk3,
  granite,
  libxml2,
  wingpanel,
  libgee,
  xorg,
  libgnomekbd,
  ibus,
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-keyboard";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "sha256-AmTAl7N+2zYRUgmnuP+S+m0n6nUIihcB5kisWoPPlTQ=";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    libxml2
    pkg-config
    vala
  ];

  buildInputs = [
    granite
    gtk3
    ibus
    libgee
    wingpanel
    xorg.xkeyboardconfig
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Keyboard Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-keyboard";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
