{ stdenv, fetchurl, pkgconfig, gtkglext, gtkmm, gtk, libGLU_combined, gdk_pixbuf
, pangox_compat, libXmu
}:

stdenv.mkDerivation rec {
  name = "gtkglextmm-${minVer}.0";
  minVer = "1.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkglextmm/${minVer}/${name}.tar.bz2";
    sha256 = "6cd4bd2a240e5eb1e3a24c5a3ebbf7ed905b522b888439778043fdeb58771fea";
  };

  patches = [
    ./gdk.patch

    # From debian, fixes build with newer gtk "[...] by switching #includes
    # around so that the G_DISABLE_DEPRECATED trick in glibmm still works".
    # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=707356
    ./fix_ftbfs_gtk_2_36.patch
  ];

  buildInputs = [ pangox_compat libXmu ];

  nativeBuildInputs = [pkgconfig];

  propagatedBuildInputs = [ gtkglext gtkmm gtk libGLU_combined gdk_pixbuf ];

  meta = {
    description = "C++ wrappers for GtkGLExt";
    license = stdenv.lib.licenses.lgpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    broken = true;
  };
}
