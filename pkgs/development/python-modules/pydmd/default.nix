{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, future
, matplotlib
, numpy
, pytestCheckHook
, pythonOlder
, scipy
, ezyrb
}:

buildPythonPackage rec {
  pname = "pydmd";
  version = "0.4.0.post2301";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "PyDMD";
    rev = "refs/tags/v${version}";
    hash = "sha256-0ss7yyT6u0if+YjBYNbKtx5beJU43JC1LD9rqHPKBS8=";
  };

  propagatedBuildInputs = [
    future
    matplotlib
    numpy
    scipy
    ezyrb
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    # test suite takes over 100 vCPU hours, just run small subset of it.
    # TODO: Add a passthru.tests with all tests
    "tests/test_dmdbase.py"
  ];

  pythonImportsCheck = [
    "pydmd"
  ];

  meta = with lib; {
    description = "Python Dynamic Mode Decomposition";
    homepage = "https://mathlab.github.io/PyDMD/";
    changelog = "https://github.com/mathLab/PyDMD/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
    broken = stdenv.hostPlatform.isAarch64;
  };
}
