{ lib
, buildPythonPackage
, fetchFromGitHub
  #, pytestCheckHook
, pythonOlder
, pkg-config
, gammu
}:

buildPythonPackage rec {
  pname = "python-gammu";
  version = "3.2.4";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "gammu";
    repo = pname;
    rev = version;
    sha256 = "sha256-lFQBrKWwdvUScwsBva08izZVeVDn1u+ldzixtL9YTpA=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    gammu
  ];

  # Check with the next release if tests could be run with pytest
  # nativeCheckInputs = [ pytestCheckHook ];
  # Don't run tests for now
  doCheck = false;

  pythonImportsCheck = [
    "gammu"
  ];

  meta = with lib; {
    description = "Python bindings for Gammu";
    homepage = "https://github.com/gammu/python-gammu/";
    license = with licenses; [ gpl2Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
