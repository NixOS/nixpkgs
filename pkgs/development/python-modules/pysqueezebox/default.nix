{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pysqueezebox";
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "rajlaud";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0ArKVRy4H0NWShlQMziKvbHp9OjpAkEKp4zrvpVlXOk=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pysqueezebox"
  ];

  disabledTestPaths = [
    # Tests require network access
    "tests/test_integration.py"
  ];

  meta = with lib; {
    description = "Asynchronous library to control Logitech Media Server";
    homepage = "https://github.com/rajlaud/pysqueezebox";
    license = licenses.asl20;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
