{ stdenv, fetchFromGitHub, pantheon, substituteAll, meson, ninja, python3
, pkgconfig, vala, granite, libgee, gettext, gtk3, appstream, gnome-menus
, json-glib, plank, bamf, switchboard, libunity, libsoup, wingpanel, libwnck3
, zeitgeist, bc }:

stdenv.mkDerivation rec {
  pname = "applications-menu";
  version = "2.4.3";

  name = "wingpanel-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "15mwfynaa57jii43x77iaz5gqjlylh5zxc70am8zgp8vhgzflvyd";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "wingpanel-${pname}";
    };
  };

  nativeBuildInputs = [
    appstream
    gettext
    meson
    ninja
    pkgconfig
    python3
    vala
   ];

  buildInputs = [
    bamf
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

  mesonFlags = [
    "--sysconfdir=${placeholder ''out''}/etc"
  ];

  PKG_CONFIG_WINGPANEL_2_0_INDICATORSDIR = "${placeholder ''out''}/lib/wingpanel";
  PKG_CONFIG_SWITCHBOARD_2_0_PLUGSDIR = "${placeholder ''out''}/lib/switchboard";

  patches = [
    (substituteAll {
      src = ./bc.patch;
      exec = "${bc}/bin/bc";
    })
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Lightweight and stylish app launcher for Pantheon";
    homepage = https://github.com/elementary/applications-menu;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
