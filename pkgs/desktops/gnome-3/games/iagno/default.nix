{ lib, stdenv
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
  version = "3.38.1";

  src = fetchurl {
    url = "mirror://gnome/sources/iagno/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "097dw1l92l73xah9l56ka5mi3dvx48ffpiv33ni5i5rqw0ng7fc4";
  };

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

  meta = with lib; {
    homepage = "https://wiki.gnome.org/Apps/Iagno";
    description = "Computer version of the game Reversi, more popularly called Othello";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
