{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  version = "3.4.7";
  pname = "pycryptodome";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pycryptodome/${name}.tar.gz";
    sha256 = "18d8dfe31bf0cb53d58694903e526be68f3cf48e6e3c6dfbbc1e7042b1693af7";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
