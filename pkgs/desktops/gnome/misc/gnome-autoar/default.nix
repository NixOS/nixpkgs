{ stdenv
, lib
, fetchurl
, fetchpatch
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
  version = "0.4.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-autoar/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "6oxtUkurxxKsWeHQ46yL8BN0gtrfM8lP6RE3lKG8RHQ=";
  };

  patches = [
    # Make compatible with older Meson.
    # https://gitlab.gnome.org/GNOME/gnome-autoar/-/merge_requests/26
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-autoar/-/commit/2d90da6174c03aad546802234a3d77fa0b714e6b.patch";
      sha256 = "CysDpBJmVPm4gOSV2h041MY2yApfAy8+4QC7Jlka1xE=";
    })
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gnome-autoar/-/commit/ac21bd0c50584a1905a0da65d4bf9a6926ecd483.patch";
      sha256 = "aTu6eKFSKjljk0TYkhFjPcD8eJCIk8TR0YhZYO9JE1k=";
    })
  ];

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
