{ stdenv
, fetchFromGitHub
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
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0jc12xfaj3micpjssxc7m6hzssvyq26ln5az05x5f1j6v8lccbyn";
  };

  passthru = {
    updateScript = pantheon.updateScript {
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
  ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      libgnomekbd_path = "${libgnomekbd}/bin/";
      config = "${xorg.xkeyboardconfig}/share/X11/xkb/rules/evdev.xml";
    })
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder "out"}/lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Keyboard Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-keyboard;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
