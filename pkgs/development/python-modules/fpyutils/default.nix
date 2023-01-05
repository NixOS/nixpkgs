{ lib
, atomicwrites
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "fpyutils";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-cmCD8uKPX/7Ak6jAqzCvDqR1FgH09GaLfLTZdBQB+bs=";
  };

  propagatedBuildInputs = [
    atomicwrites
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "fpyutils/tests/*.py"
  ];

  disabledTests = [
    # Don't run test which requires bash
    "test_execute_command_live_output"
  ];

  pythonImportsCheck = [
    "fpyutils"
  ];

  meta = with lib; {
    description = "Collection of useful non-standard Python functions";
    homepage = "https://github.com/frnmst/fpyutils";
    changelog = "https://blog.franco.net.eu.org/software/fpyutils-${version}/release.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
