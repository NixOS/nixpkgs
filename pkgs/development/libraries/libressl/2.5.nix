{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.5.4";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "1ykf6dqlbafafhbdfmcj19pjj1z6wmsq0rmyqga1i0xv5x95nyhh";
  };

  enableParallelBuilding = true;

  outputs = [ "bin" "dev" "out" "man" ];

  dontGzipMan = if stdenv.isDarwin then true else null; # not sure what's wrong

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice wkennington fpletz globin ];
  };
}
