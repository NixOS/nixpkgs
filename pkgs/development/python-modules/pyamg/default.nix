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
  version = "4.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4cacfcfd13379762a4551ac059a2e52a093b476ca1ad44b9202e736490a8863";
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
    homepage = "https://github.com/pyamg/pyamg";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
