{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl }:

stdenv.mkDerivation rec {
  name = "clutter-gst-2.0.12";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/2.0/${name}.tar.xz";
    sha256 = "1dgzpd5l5ld622b8185c3khvvllm5hfvq4q1a1mgzhxhj8v4bwf2";
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
