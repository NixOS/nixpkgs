{ stdenv, fetchurl, pkgconfig, glib, gdk_pixbuf, libsigcxx }:

stdenv.mkDerivation rec {
  name = "glibmm-2.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/glibmm/2.34/${name}.tar.xz";
    sha256 = "1i4jsvahva2q0mig7kjnpsw0r3fnpybm8b6hzymfm2hpgqnaa9dl";
  };

  buildNativeInputs = [ pkgconfig ];
  propagatedBuildInputs = [ glib gdk_pixbuf libsigcxx ];

  meta = {
    description = "C++ interface to the GLib library";

    homepage = http://gtkmm.org/;

    license = "LGPLv2+";

    maintainers = with stdenv.lib.maintainers; [urkud raskin];
    platforms = stdenv.lib.platforms.linux;
  };
}
