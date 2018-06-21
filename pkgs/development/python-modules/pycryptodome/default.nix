{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  version = "3.6.2";
  pname = "pycryptodome";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://pypi/p/pycryptodome/${name}.tar.gz";
    sha256 = "b19ed0f7752a0b1ec65834c9acb02ba64a812990854e318d32a619c709b14a69";
  };

  meta = {
    homepage = https://www.pycryptodome.org/;
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
