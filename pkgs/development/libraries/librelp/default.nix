{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "librelp-1.2.12";

  src = fetchurl {
    url = "http://download.rsyslog.com/librelp/${name}.tar.gz";
    sha256 = "1mvvxqfsfg96rb6xv3fw7mcsqmyfnsb74sc53gnhpcpp4h2p6m83";
  };

  buildInputs = [ pkgconfig gnutls zlib ];

  meta = with stdenv.lib; {
    homepage = http://www.librelp.com/;
    description = "A reliable logging library";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
