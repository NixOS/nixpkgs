{ stdenv, fetchurl, pkgconfig, glib, intltool, json-glib, librest, libsoup, gnome3, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "libzapojit";
  version = "0.0.3";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0zn3s7ryjc3k1abj4k55dr2na844l451nrg9s6cvnnhh569zj99x";
  };

  nativeBuildInputs = [ pkgconfig intltool gobject-introspection ];
  propagatedBuildInputs = [ glib json-glib librest libsoup gnome3.gnome-online-accounts ]; # zapojit-0.0.pc

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    description = "GObject wrapper for the SkyDrive and Hotmail REST APIs";
    homepage = https://wiki.gnome.org/Projects/Zapojit;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
