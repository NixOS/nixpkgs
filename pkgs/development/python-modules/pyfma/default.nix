{ lib
, buildPythonPackage
, fetchPypi
, pybind11
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c9ea44c5e30ca8318ca794ff1e3941d3dc7958901b1a9c430d38734bf7b6f8d";
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
