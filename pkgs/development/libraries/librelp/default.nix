{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "librelp-1.2.14";

  src = fetchurl {
    url = "http://download.rsyslog.com/librelp/${name}.tar.gz";
    sha256 = "0marms2np729ck0x0hsj1bdmi0ly57pl7pfspwrqld9n8cd29xhi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gnutls zlib ];

  meta = with stdenv.lib; {
    homepage = http://www.librelp.com/;
    description = "A reliable logging library";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
