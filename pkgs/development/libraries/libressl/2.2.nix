{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.2.6";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "0kynb15l5gq1qgp3p4ncn20sc65sbl8lk89vyr07s17xrya9kq8y";
  };

  enableParallelBuilding = true;

  outputs = [ "dev" "out" "man" "bin" ];

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice wkennington fpletz globin ];
  };
}
