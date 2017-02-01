{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.3.10";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "1ly4aid64jnj74kk8182nwcd5kbivpwdbyllq6ik3vf5w2nml2rd";
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
