{ lib
, buildPythonPackage
, fetchFromGitHub
, bluepy
, pythonOlder
}:

buildPythonPackage rec {
  pname = "cometblue-lite";
  version = "0.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "neffs";
    repo = "python-cometblue_lite";
    rev = version;
    sha256 = "sha256-kK6P8almFQac/bt7we02Q96RIB/s9wAqb+dn09tFx7k=";
  };

  propagatedBuildInputs = [
    bluepy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "cometblue_lite"
  ];

  meta = with lib; {
    description = "Python module for Eurotronic Comet Blue thermostats";
    homepage = "https://github.com/neffs/python-cometblue_lite";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
