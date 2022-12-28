{ lib
, bleak
, bleak-retry-connector
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cometblue-lite";
  version = "0.5.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "neffs";
    repo = "python-cometblue_lite";
    rev = version;
    hash = "sha256-KRWS2nqMFlF+IcBSmnQH3ptp6yxRQjAFY6aY0D7eZBs=";
  };

  propagatedBuildInputs = [
    bleak
    bleak-retry-connector
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "cometblue_lite"
  ];

  meta = with lib; {
    description = "Module for Eurotronic Comet Blue thermostats";
    homepage = "https://github.com/neffs/python-cometblue_lite";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
