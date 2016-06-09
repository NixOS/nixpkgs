{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl }:

stdenv.mkDerivation rec {
  major = "3.0";
  minor = "18";
  name = "clutter-gst-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/${major}/${name}.tar.xz";
    sha256 = "14w0pi9myvcn1yxzmk9sk8dghj17m5ji3aqdpfjikk90c060vv0a";
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
