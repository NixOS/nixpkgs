{ lib
, stdenv
, fetchFromGitHub
, buildPythonPackage
, unittestCheckHook
, flit-core
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
  version = "4.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "qpsolvers";
    repo = "qpsolvers";
    rev = "refs/tags/v${version}";
    hash = "sha256-/HLc9dFf9F/6W7ux2Fj2yJuV/xCVeGyO6MblddwIGdM=";
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
    flit-core
    quadprog
    unittestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/qpsolvers/qpsolvers/blob/${src.rev}/CHANGELOG.md";
    description = "Quadratic programming solvers in Python with a unified API";
    homepage = "https://github.com/qpsolvers/qpsolvers";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ renesat ];
  };
}
