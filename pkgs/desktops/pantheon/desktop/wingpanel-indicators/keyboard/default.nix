{ stdenv, fetchFromGitHub, pantheon, pkgconfig, meson, ninja
, substituteAll, vala, gtk3, granite, libxml2, wingpanel, libgee
, xorg, libgnomekbd, gobject-introspection, elementary-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "wingpanel-indicator-keyboard";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0x0bdd9svw4sffx8pa0pqlh6mrj3fqp4mgrb4n7ys26k2w20ngnb";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
    };
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
    libxml2
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    elementary-icon-theme
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

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "lib/wingpanel";

  meta = with stdenv.lib; {
    description = "Keyboard Indicator for Wingpanel";
    homepage = https://github.com/elementary/wingpanel-indicator-keyboard;
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
