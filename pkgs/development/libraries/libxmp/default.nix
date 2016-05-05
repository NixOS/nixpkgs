{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libxmp-4.3.12";

  meta = with stdenv.lib; {
    description = "Extended module player library";
    homepage    = "http://xmp.sourceforge.net/";
    longDescription = ''
      Libxmp is a library that renders module files to PCM data. It supports
      over 90 mainstream and obscure module formats including Protracker (MOD),
      Scream Tracker 3 (S3M), Fast Tracker II (XM), and Impulse Tracker (IT).
    '';
    license     = licenses.lgpl21Plus;
    platforms   = platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/xmp/libxmp/${name}.tar.gz";
    sha256 = "1536dfxgxl6dyvkdby8lxzi9f7y2qlwl8ylrkybips3ampcqgkhm";
  };
}
