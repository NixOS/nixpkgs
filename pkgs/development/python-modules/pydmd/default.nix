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
}:

buildPythonPackage rec {
  pname = "pydmd";
  version = "0.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "mathLab";
    repo = "PyDMD";
    rev = "v${version}";
    sha256 = "1qwa3dyrrm20x0pzr7rklcw7433fd822n4m8bbbdd7z83xh6xm8g";
  };

  propagatedBuildInputs = [
    future
    matplotlib
    numpy
    scipy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Those tests take over 1.5 h on hydra. Also, an error and two failures
    "tests/test_spdmd.py"
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
