{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.2.1";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "0bapzvxrg09p4hlzdhsvk0ljc3gsjj4ixjpf09dn0fzwmd81fcsg";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice wkennington ];
  };
}
