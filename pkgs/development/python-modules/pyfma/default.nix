{ lib
, buildPythonPackage
, fetchPypi
, pybind11
, numpy
, pytest
}:

buildPythonPackage rec {
  pname = "pyfma";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "79514717f8e632a0fb165e3d61222ed61202bea7b0e082f7b41c91e738f1fbc9";
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
    homepage = https://github.com/nschloe/pyfma;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc];
  };
}
