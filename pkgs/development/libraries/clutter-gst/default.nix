{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl, gnome3, gdk_pixbuf }:

let
  pname = "clutter-gst";
  version = "3.0.27";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "17czmpl92dzi4h3rn5rishk015yi3jwiw29zv8qan94xcmnbssgy";
  };

  propagatedBuildInputs = [ clutter gtk3 glib cogl gdk_pixbuf ];
  nativeBuildInputs = [ pkgconfig ];

  postBuild = "rm -rf $out/share/gtk-doc";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "GStreamer bindings for clutter";

    homepage = http://www.clutter-project.org/;

    license = stdenv.lib.licenses.lgpl2Plus;

    maintainers = with stdenv.lib.maintainers; [ lethalman ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
