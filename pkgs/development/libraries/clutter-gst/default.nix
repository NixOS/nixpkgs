{ fetchurl, stdenv, pkgconfig, clutter, gtk3, glib, cogl, gnome3 }:

let
  pname = "clutter-gst";
  version = "3.0.26";
in stdenv.mkDerivation rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "0fnblqm4igdx4rn3681bp1gm1y2i00if3iblhlm0zv6ck9nqlqfq";
  };

  propagatedBuildInputs = [ clutter gtk3 glib cogl ];
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
