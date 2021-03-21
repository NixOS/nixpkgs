{ fetchurl, lib, stdenv, pkg-config, intltool, gobject-introspection, glib, gdk-pixbuf
, libxml2, cairo, pango, gnome3 }:

stdenv.mkDerivation rec {
  pname = "lasem";
  version = "0.5.1";

  outputs = [ "bin" "out" "dev" "man" "doc" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0hxlcqngznchv71mqjjq0j9pai83jpr7mfvhxh6qljy99fc1kw2i";
  };

  nativeBuildInputs = [ pkg-config intltool gobject-introspection ];

  propagatedBuildInputs = [
    glib gdk-pixbuf libxml2 cairo pango
  ];

  enableParallelBuilding = true;
  doCheck = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "odd-unstable";
    };
  };

  meta = {
    description = "SVG and MathML rendering library";

    homepage = "https://wiki.gnome.org/Projects/Lasem";
    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
  };
}
