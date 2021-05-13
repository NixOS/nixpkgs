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
  version = "2.0.0";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "frnmst";
    repo = pname;
    rev = version;
    sha256 = "1n15fvd6191ixxsza49fdd8j43hs0agagg8k9v6rc7by1ffqnl2b";
  };

  propagatedBuildInputs = [
    atomicwrites
    requests
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "fpyutils/tests/*.py" ];

  disabledTests = [
    # Don't run test which requires bash
    "test_execute_command_live_output"
  ];

  pythonImportsCheck = [ "fpyutils" ];

  meta = with lib; {
    description = "Collection of useful non-standard Python functions";
    homepage = "https://github.com/frnmst/fpyutils";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
