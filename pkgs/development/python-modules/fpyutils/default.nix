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
  version = "2.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5dikfR648AhQUMX/hS0igIy9gnMyxUHddp1xaxNyYCo=";
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
    changelog = "https://blog.franco.net.eu.org/software/fpyutils-3.0.1/release.html";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
