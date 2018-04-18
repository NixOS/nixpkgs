{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  version = "3.5.1";
  pname = "pycryptodome";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pycryptodome/${name}.tar.gz";
    sha256 = "b7957736f5e868416b06ff033f8525e64630c99a8880b531836605190b0cac96";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
