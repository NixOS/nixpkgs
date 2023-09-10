{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, unittestCheckHook
, daqp
, ecos
, numpy
, osqp
, scipy
, scs
, quadprog
}:
buildPythonPackage rec {
  pname = "qpsolvers";
  version = "3.4.0";
  format = "flit";

  src = fetchFromGitHub {
    owner = "qpsolvers";
    repo = "qpsolvers";
    rev = "v${version}";
    hash = "sha256-GrYAhTWABBvU6rGoHi00jBa7ryjCNgzO/hQBTdSW9cg=";
  };

  pythonImportsCheck = [ "qpsolvers" ];

  propagatedBuildInputs = [
    daqp
    ecos
    numpy
    osqp
    scipy
    scs
  ];

  nativeCheckInputs = [
    quadprog
    unittestCheckHook
  ];

  meta = with lib; {
    description = "Quadratic programming solvers in Python with a unified API";
    homepage = "https://github.com/qpsolvers/qpsolvers";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ renesat ];
  };
}
