{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pytest-asyncio
, pytest-sugar
, pytest-timeout
, pytestCheckHook
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "pylutron-caseta";
  version = "0.18.2";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "gurumitts";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-GyYJZIjvy4JYNCUUJpQxt32U8lMS/iQoz4llbCmJQhU=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-sugar
    pytest-timeout
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "pylutron_caseta"
  ];

  meta = with lib; {
    description = "Python module o control Lutron Caseta devices";
    homepage = "https://github.com/gurumitts/pylutron-caseta";
    changelog = "https://github.com/gurumitts/pylutron-caseta/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
