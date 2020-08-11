{ stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, pkgconfig
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
}:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-keyboard";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0q32qc6jh5w0i1ixkl59pys8r3hxmbig8854q7sxi07vlk9g3i7y";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    libxml2
    pkgconfig
    vala
  ];

  buildInputs = [
    granite
    gtk3
    libgee
    wingpanel
    xorg.xkeyboardconfig
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      gkbd_keyboard_display = "${libgnomekbd}/bin/gkbd-keyboard-display";
    })
  ];

  meta = with stdenv.lib; {
    description = "Keyboard Indicator for Wingpanel";
    homepage = "https://github.com/elementary/wingpanel-indicator-keyboard";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
