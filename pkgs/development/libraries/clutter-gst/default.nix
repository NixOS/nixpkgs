{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl }:

stdenv.mkDerivation rec {
  major = "3.0";
  minor = "20";
  name = "clutter-gst-${major}.${minor}";

  src = fetchurl {
    url = "mirror://gnome/sources/clutter-gst/${major}/${name}.tar.xz";
    sha256 = "1jb6q0f6vbh8nskz88siny70pm43wbnw2wzr2klsyb9axn3if0d0";
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
