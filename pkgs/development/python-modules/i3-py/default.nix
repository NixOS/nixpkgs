{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.6.4";
  format = "setuptools";
  pname = "i3-py";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1sgl438jrb4cdyl7hbc3ymwsf7y3zy09g1gh7ynilxpllp37jc8y";
  };

  # no tests in tarball
  doCheck = false;

  meta = {
    description = "Tools for i3 users and developers";
    homepage = "https://github.com/ziberna/i3-py";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
}
