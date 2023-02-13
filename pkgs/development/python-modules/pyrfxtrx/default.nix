{ lib
, buildPythonPackage
, fetchFromGitHub
, pyserial
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyrfxtrx";
  version = "0.30.0";

  src = fetchFromGitHub {
    owner = "Danielhiversen";
    repo = "pyRFXtrx";
    rev = "refs/tags/${version}";
    hash = "sha256-ntnZITj8upzUzlrSTjQxY9xNTU+gJ2rE9PN35cpWwvM=";
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
