{ stdenv, fetchurl
, pkgconfig
, intltool
, URI
, glib, gtk
, libxfce4util
}:

stdenv.mkDerivation {
  name = "libexo-0.3.106";
  src = fetchurl {
    url = http://archive.xfce.org/src/xfce/exo/0.3/exo-0.3.106.tar.bz2;
    sha256 = "1n823ipqdz47kxq6fwry3zza3j9ap7gikwm4s8169297xcjqd6qb";
  };

  buildInputs = [ pkgconfig intltool URI glib gtk libxfce4util ];

  meta = {
    homepage = http://www.xfce.org/projects/exo;
    description = "Application library for the Xfce desktop environment";
    license = "GPLv2+";
  };
}
