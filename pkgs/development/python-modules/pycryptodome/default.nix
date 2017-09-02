{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  version = "3.4.6";
  pname = "pycryptodome";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pycryptodome/${name}.tar.gz";
    sha256 = "df1be662060cf3abdcf2086ebb401f750744106425ddebf74c57feab410e4923";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
