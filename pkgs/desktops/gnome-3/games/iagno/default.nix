{ stdenv
, fetchurl
, fetchpatch
, pkg-config
, gtk3
, gnome3
, gdk-pixbuf
, librsvg
, wrapGAppsHook
, itstool
, gsound
, libxml2
, meson
, ninja
, python3
, vala
, desktop-file-utils
}:

stdenv.mkDerivation rec {
  pname = "iagno";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fd7bmym35b43d2gp6ngablry85gb2j52gp4lgqd098hbn5ziaf4";
  };

  patches = [
    # Fix build with Meson 0.55
    # https://gitlab.gnome.org/GNOME/iagno/-/issues/16
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/iagno/commit/0100bab269f2102f24a6e41202b931da1b6e8dc5.patch";
      sha256 = "ZW75s+bV45ivwA+SKUN7ejSvnXYEo/kYQjDVvFBA/sg=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    python3
    vala
    desktop-file-utils
    pkg-config
    wrapGAppsHook
    itstool
    libxml2
  ];

  buildInputs = [
    gtk3
    gnome3.adwaita-icon-theme
    gdk-pixbuf
    librsvg
    gsound
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "iagno";
      attrPath = "gnome3.iagno";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Iagno";
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
