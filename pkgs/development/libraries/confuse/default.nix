{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "confuse";
  version = "2.7";
  src = fetchurl {
    url = "http://savannah.nongnu.org/download/confuse/${name}-${version}.tar.gz";
    sha256 = "0y47r2ashz44wvnxdb18ivpmj8nxhw3y9bf7v9w0g5byhgyp89g3";
  };

  meta = {
    homepage = http://www.nongnu.org/confuse/;
    description = "Configuration file parser library";
    license = "BSD";
  };
}
