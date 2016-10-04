{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.3.8";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "1hjglpaw1bparlzyjczn0rak32n8hl53317izq81683x5kns8smf";
  };

  enableParallelBuilding = true;

  outputs = [ "bin" "dev" "out" "man" ];

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice wkennington fpletz globin ];
  };
}
