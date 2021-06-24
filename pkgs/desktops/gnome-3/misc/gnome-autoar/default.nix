{ lib, stdenv
, fetchurl
, pkg-config
, gnome3
, gtk3
, glib
, gobject-introspection
, libarchive
, vala
}:

stdenv.mkDerivation rec {
  pname = "gnome-autoar";
  version = "0.3.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1y6hh5dldhdq7mpbmd571zl0yadfackvifhnxvykkqqddwz72y0f";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-autoar"; attrPath = "gnome3.gnome-autoar"; };
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
