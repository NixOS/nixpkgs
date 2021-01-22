{ fetchurl, lib, stdenv, pkg-config, intltool, gobject-introspection, glib, gdk-pixbuf
, libxml2, cairo, pango, gnome3 }:

stdenv.mkDerivation rec {
  pname = "lasem";
  version = "0.4.4";

  outputs = [ "bin" "out" "dev" "man" "doc" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0fds3fsx84ylsfvf55zp65y8xqjj5n8gbhcsk02vqglivk7izw4v";
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
    };
  };

  meta = {
    description = "SVG and MathML rendering library";

    homepage = "https://wiki.gnome.org/Projects/Lasem";
    license = lib.licenses.gpl2Plus;

    platforms = lib.platforms.unix;
  };
}
