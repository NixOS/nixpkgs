{ stdenv, fetchurl, boost, pkgconfig, librevenge, zlib }:

stdenv.mkDerivation rec {
  name = "libwps-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/libwps/${name}.tar.gz";
    sha256 = "0nc44ia5sn9mmhkq5hjacz0vm520wldq03whc5psgcb9dahvsjsc";
  };

  buildInputs = [ boost pkgconfig librevenge zlib ];

  meta = with stdenv.lib; {
    homepage = http://libwps.sourceforge.net/;
    description = "Microsoft Works file word processor format import filter library";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
