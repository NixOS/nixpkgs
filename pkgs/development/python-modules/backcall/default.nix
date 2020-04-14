{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "backcall";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "38ecd85be2c1e78f77fd91700c76e14667dc21e2713b63876c0eb901196e01e4";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Specifications for callback functions passed in to an API";
    homepage = "https://github.com/takluyver/backcall";
    license = lib.licenses.bsd3;
  };

}
