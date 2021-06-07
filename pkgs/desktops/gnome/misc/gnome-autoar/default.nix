{ lib, stdenv
, fetchurl
, pkg-config
, gnome
, gtk3
, glib
, gobject-introspection
, libarchive
, vala
}:

stdenv.mkDerivation rec {
  pname = "gnome-autoar";
  version = "0.3.2";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0wkwix44yg126xn1v4f2j60bv9yiyadfpzf8ifx0bvd9x5f4v354";
  };

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-autoar"; attrPath = "gnome.gnome-autoar"; };
  };

  nativeBuildInputs = [
    gobject-introspection
    pkg-config
    vala
  ];

  buildInputs = [
    gtk3
  ];

  propagatedBuildInputs = [
    libarchive
    glib
  ];

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    description = "Library to integrate compressed files management with GNOME";
  };
}
