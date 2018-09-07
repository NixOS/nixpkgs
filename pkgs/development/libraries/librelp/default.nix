{ stdenv, fetchurl, pkgconfig, gnutls, zlib }:

stdenv.mkDerivation rec {
  name = "librelp-1.2.17";

  src = fetchurl {
    url = "http://download.rsyslog.com/librelp/${name}.tar.gz";
    sha256 = "1w6blhfr3rlmvjj0fbr8rsycrkm5b92n44zaaijg1jnvxjfqpy0v";
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
