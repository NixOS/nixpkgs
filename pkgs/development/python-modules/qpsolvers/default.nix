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
  version = "4.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "qpsolvers";
    repo = "qpsolvers";
    rev = "refs/tags/v${version}";
    hash = "sha256-KkV61pBkIh+4Qav9TVobEBUCyMa6Xqg+eygnOoQRpcQ=";
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
    description = "Quadratic programming solvers in Python with a unified API";
    homepage = "https://github.com/qpsolvers/qpsolvers";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ renesat ];
  };
}
