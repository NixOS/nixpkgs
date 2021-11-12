{ stdenv
, lib
, fetchurl
, meson
, ninja
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
  version = "0.4.1";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "ZGvVDrrZLZHBvokJehU2QVYVdELKwUcd7X7LJ9mpFQ4=";
  };

  nativeBuildInputs = [
    gobject-introspection
    meson
    ninja
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

  mesonFlags = [
    "-Dvapi=true"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-autoar";
      attrPath = "gnome.gnome-autoar";
    };
  };

  meta = with lib; {
    platforms = platforms.linux;
    maintainers = teams.gnome.members;
    license = licenses.lgpl21Plus;
    description = "Library to integrate compressed files management with GNOME";
  };
}
