{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "arris-tg2492lg";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vanbalken";
    repo = pname;
    rev = version;
    hash = "sha256-MQq9jMUoJgqaY0f9YIbhME2kO+ektPqBnT9REg3qDpg=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "arris_tg2492lg"
  ];

  meta = with lib; {
    description = "Library to connect to an Arris TG2492LG";
    homepage = "https://github.com/vanbalken/arris-tg2492lg";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
