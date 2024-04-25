{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyrfxtrx";
  version = "0.31.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    rev = "refs/tags/${version}";
    hash = "sha256-Y9UVJZxm5G5ywNLW8nm162cZTs3/mFeI+ZEUGoc9eAs=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # https://github.com/Danielhiversen/pyRFXtrx/issues/130
    "tests/test_rollertrol.py"
  ];

  meta = with lib; {
    description = "Library to communicate with the RFXtrx family of devices";
    homepage = "https://github.com/Danielhiversen/pyRFXtrx";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
