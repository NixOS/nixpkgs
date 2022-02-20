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
  version = "4.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "48d9be622049d8363cda84125c45d18b89e0ab7d99be5a93c0246f375ebad344";
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
