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
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "quadprog";
    repo = "quadprog";
    rev = "v${version}";
    hash = "sha256-8gPuqDY3ajw/+B6kJdtpq+HL+Oq2Nsy/O7m+IWzxP38=";
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
