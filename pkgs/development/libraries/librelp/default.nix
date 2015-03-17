{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "librelp-1.2.7";

  src = fetchurl {
    url = "http://download.rsyslog.com/librelp/${name}.tar.gz";
    sha256 = "1lfpd06cchi1mhlxwq0xhmbx42b8isx9677v9h80c9vpf4f4lhrs";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  meta = with stdenv.lib; {
    homepage = http://www.librelp.com/;
    description = "a reliable logging library";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
