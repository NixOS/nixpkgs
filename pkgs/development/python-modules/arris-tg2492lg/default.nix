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
  version = "2.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vanbalken";
    repo = pname;
    rev = version;
    sha256 = "sha256-C1o9HWWJ/G/7Pp6I0FbRmX2PQvUJx71L9wHRkUMtnL4=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  checkInputs = [
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
