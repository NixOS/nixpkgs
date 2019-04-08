{ stdenv, fetchFromGitHub, pantheon, substituteAll, cmake, ninja
, pkgconfig, vala, granite, libgee, gettext, gtk3, appstream, gnome-menus
, json-glib, plank, bamf, switchboard, libunity, libsoup, wingpanel, libwnck3
, zeitgeist, gobject-introspection, elementary-icon-theme, bc, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "applications-menu";
  version = "2.4.2";

  name = "wingpanel-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "0y7kh50ixvm4m56v18c70s05hhpfp683c4qi3sxy50p2368d772x";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "wingpanel-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    cmake
    ninja
    gettext
    gobject-introspection
    pkgconfig
    vala
    wrapGAppsHook
   ];

  buildInputs = [
    bamf
    elementary-icon-theme
    gnome-menus
    granite
    gtk3
    json-glib
    libgee
    libsoup
    libunity
    libwnck3
    plank
    switchboard
    wingpanel
    zeitgeist
   ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "lib/wingpanel";
  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "lib/switchboard";

  patches = [
    (substituteAll {
      src = ./bc.patch;
      exec = "${bc}/bin/bc";
    })
    ./xdg.patch
  ];

  meta = with stdenv.lib; {
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = https://github.com/elementary/applications-menu;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
