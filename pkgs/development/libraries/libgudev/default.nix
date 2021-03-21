{ lib, stdenv
, fetchurl
, pkg-config
, meson
, ninja
, udev
, glib
, gobject-introspection
, gnome3
, vala
}:

stdenv.mkDerivation rec {
  pname = "libgudev";
  version = "236";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "094mgjmwgsgqrr1i0vd20ynvlkihvs3vgbmpbrhswjsrdp86j0z5";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
    meson
    ninja
    vala
  ];

  buildInputs = [
    udev
    glib
  ];

  mesonFlags = [
    # There's a dependency cycle with umockdev and the tests fail to LD_PRELOAD anyway
    "-Dtests=disabled"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "A library that provides GObject bindings for libudev";
    homepage = "https://wiki.gnome.org/Projects/libgudev";
    maintainers = [ maintainers.eelco ] ++ teams.gnome.members;
    platforms = platforms.linux;
    license = licenses.lgpl2Plus;
  };
}
