{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, pytestCheckHook
, python-gvm
, pythonOlder
}:

buildPythonPackage rec {
  pname = "gvm-tools";
  version = "21.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-LGdbqkIKdmtUOGSoCme6oVG1aCbtASSxi9K9f3khafA=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    python-gvm
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Don't test sending
    "SendTargetTestCase"
  ];

  pythonImportsCheck = [
    "gvmtools"
  ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
