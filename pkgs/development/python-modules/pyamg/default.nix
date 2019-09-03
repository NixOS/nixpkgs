{ lib
, buildPythonPackage
, fetchPypi
, numpy
, scipy
, pytest
, pybind11
}:

buildPythonPackage rec {
  pname = "pyamg";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "3ceb38ffd86e29774e759486f2961599c8ed847459c68727493cadeaf115a38a";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    pytest
    pybind11
  ];

  preBuild = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "Algebraic Multigrid Solvers in Python";
    homepage = https://github.com/pyamg/pyamg;
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
