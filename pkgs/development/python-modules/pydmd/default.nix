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
  version = "0.4.0.post2211";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "PyDMD";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-DTKw7Gy2w+zas9u62SN6QDhoeMEjSk/Ej09do38yfNY=";
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
    license = licenses.mit;
    maintainers = with maintainers; [ yl3dy ];
    broken = stdenv.hostPlatform.isAarch64;
  };
}
