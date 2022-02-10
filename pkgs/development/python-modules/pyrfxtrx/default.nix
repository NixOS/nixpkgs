{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyrfxtrx";
  version = "0.27.1";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    rev = version;
    hash = "sha256-JBU/ApBumdW87fQqMAopzv+UV0f6VsHMiyNqG7BRLgo=";
  };

  propagatedBuildInputs = [
    pyserial
  ];

  checkInputs = [
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
