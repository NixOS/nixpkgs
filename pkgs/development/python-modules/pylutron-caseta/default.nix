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
  version = "0.15.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-dw/uCEY4+kpgNjbjgvw+kSfluziIK6NvIKo5QIjt+GQ=";
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

  pytestFlagsArray = [
    "--asyncio-mode=legacy"
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
