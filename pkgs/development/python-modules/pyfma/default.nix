{ lib
, buildPythonPackage
, fetchPypi
, pybind11
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3a9e2503fd01baa4978af5f491b79b7646d7872df9ecc7ab63ba10c250c50d8a";
  };

  buildInputs = [
    pybind11
  ];

  checkInputs = [
    numpy
    pytest
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    pytest test
  '';

  meta = with lib; {
    description = "Fused multiply-add for Python";
    homepage = "https://github.com/nschloe/pyfma";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc];
  };
}
