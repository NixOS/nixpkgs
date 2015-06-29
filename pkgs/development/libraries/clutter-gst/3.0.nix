{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl }:

stdenv.mkDerivation rec {
  name = "clutter-gst-3.0.4";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/3.0/${name}.tar.xz";
    sha256 = "0ahn6m9ca78cgf7xad16sb50x4dx0fcn5ircllilkir84iri2466";
  };

  propagatedBuildInputs = [ clutter gtk3 glib cogl ];
  nativeBuildInputs = [ pkgconfig ];

  postBuild = "rm -rf $out/share/gtk-doc";

  meta = {
    description = "GStreamer bindings for clutter";

    homepage = http://www.clutter-project.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ lethalman ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
