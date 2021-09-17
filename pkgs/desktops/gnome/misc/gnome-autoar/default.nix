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
  version = "0.3.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "JyQA9zo3Wn6I/fHhJZG/uPPwPt8BeAytzXT3C2E+XAQ=";
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
