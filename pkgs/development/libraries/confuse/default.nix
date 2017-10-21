{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "confuse-2.7";
  src = fetchurl {
    url = "mirror://savannah/confuse/${name}.tar.gz";
    sha256 = "0y47r2ashz44wvnxdb18ivpmj8nxhw3y9bf7v9w0g5byhgyp89g3";
  };

  meta = {
    homepage = http://www.nongnu.org/confuse/;
    description = "Configuration file parser library";
    license = stdenv.lib.licenses.isc;
    platforms = stdenv.lib.platforms.unix;
  };
}
