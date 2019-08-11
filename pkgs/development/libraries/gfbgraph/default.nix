{ stdenv, fetchurl, pkgconfig, glib, librest
, gnome3, libsoup, json-glib, gobject-introspection }:

stdenv.mkDerivation rec {
  pname = "gfbgraph";
  version = "0.2.3";

  outputs = [ "out" "dev" "devdoc" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1dp0v8ia35fxs9yhnqpxj3ir5lh018jlbiwifjfn8ayy7h47j4fs";
  };

  nativeBuildInputs = [ pkgconfig gobject-introspection ];
  buildInputs = [ glib gnome3.gnome-online-accounts ];
  propagatedBuildInputs = [ libsoup json-glib librest ];

  configureFlags = [ "--enable-introspection" ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/GFBGraph;
    description = "GLib/GObject wrapper for the Facebook Graph API";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
