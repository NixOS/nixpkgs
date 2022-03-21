{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-asyncio
, pytest-sugar
, pytest-timeout
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pylutron-caseta";
  version = "0.13.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NLVxEor+Z+AVF+0/ugPM4bpeKba6yd43uTLYhtTNhqM=";
  };

  propagatedBuildInputs = [
    cryptography
  ];

  checkInputs = [
    pytest-asyncio
    pytest-sugar
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pylutron_caseta"
  ];

  meta = with lib; {
    description = "Python module o control Lutron Caseta devices";
    homepage = "https://github.com/gurumitts/pylutron-caseta";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
