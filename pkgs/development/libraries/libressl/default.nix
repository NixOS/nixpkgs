{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.1.4";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "0km0m4y442gf0sn4g31cljhvfi3l627fw4lljyd12x47j8sqbq78";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
  };
}
