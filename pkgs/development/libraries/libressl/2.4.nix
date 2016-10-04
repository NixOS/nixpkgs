{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.4.3";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "03ln2ac9cv0pbz3109yjk7cr5yxqfk8ld6g61k9sgrs7wbrjcmxx";
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
