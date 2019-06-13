{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "librelp-1.3.0";

  src = fetchurl {
    url = "http://download.rsyslog.com/librelp/${name}.tar.gz";
    sha256 = "1xg99ndn65984mrh30qvys5npc73ag4348whshghrcj9azya494z";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls zlib ];

  meta = with stdenv.lib; {
    homepage = https://www.librelp.com/;
    description = "A reliable logging library";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
