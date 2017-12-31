{ lib
, buildPythonPackage
, fetchPypi
, python
}:

buildPythonPackage rec {
  pname = "backports_abc";
  version = "0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b3e4092ba3d541c7a2f9b7d0d9c0275b21c6a01c53a61c731eba6686939d0a5";
  };

  checkPhase = ''
    ${python.interpreter} -m unittest discover
  '';

  meta = {
    homepage = https://github.com/cython/backports_abc;
    license = lib.licenses.psfl;
    description = "A backport of recent additions to the 'collections.abc' module";
  };
}