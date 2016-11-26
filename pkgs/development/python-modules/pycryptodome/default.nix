{ stdenv, fetchurl, python, buildPythonPackage, gmp }:

buildPythonPackage rec {
  version = "3.4.3";
  name = "pycryptodome-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "mirror://pypi/p/pycryptodome/${name}.tar.gz";
    sha256 = "1x2kk2va77lqys2dd7gwh35m4vrp052zz5hvv1zqxzksg2srf5jb";
  };

  meta = {
    homepage = "https://www.pycryptodome.org/";
    description = "Python Cryptography Toolkit";
    platforms = stdenv.lib.platforms.unix;
  };
}
