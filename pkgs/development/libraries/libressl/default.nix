{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libressl-${version}";
  version = "2.1.3";

  src = fetchurl {
    url    = "mirror://openbsd/LibreSSL/${name}.tar.gz";
    sha256 = "0z2g609526pc8zmz2frkmhlfgvn8cmj5agj5yq5b33s0f44kfbzb";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Free TLS/SSL implementation";
    homepage    = "http://www.libressl.org";
    platforms   = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
