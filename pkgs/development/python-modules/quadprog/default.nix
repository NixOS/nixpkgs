{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  cython,
  setuptools,
  numpy,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage rec {
  pname = "quadprog";
  version = "0.1.12";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "quadprog";
    repo = "quadprog";
    rev = "v${version}";
    hash = "sha256-3S846PaNfZ4j3r6Vi2o6+Jk+2kC/P7tMSQQiB/Kx8nI=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
  ];

  meta = with lib; {
    homepage = "https://github.com/quadprog/quadprog";
    changelog = "https://github.com/quadprog/quadprog/releases/tag/v${version}";
    description = "Quadratic Programming Solver";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
