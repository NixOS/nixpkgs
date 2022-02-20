{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, pkg-config
, meson
, ninja
, substituteAll
, vala
, gtk3
, granite
, libxml2
, wingpanel
, libgee
, xorg
, libgnomekbd
, ibus
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-keyboard";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "10zzsil5l6snz47nx887r22sl2n0j6bg4dhxmgk3j3xp3jhgmrgl";
  };

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })
    # Upstream code not respecting our localedir
    # https://github.com/elementary/wingpanel-indicator-keyboard/pull/110
    (fetchpatch {
      url = "https://github.com/elementary/wingpanel-indicator-keyboard/commit/ea5df2f62a99a216ee5ed137268e710490a852a4.patch";
      sha256 = "0fmdz10xgzsryj0f0dnpjrh9yygjkb91a7pxg0rwddxbprhnr7j0";
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
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Keyboard Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-keyboard";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
