{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aioqsw";
  version = "0.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Z7Q9b+ameddvGu9KJUNsaqOHiu0qXnpzuiZwg+/0+64=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aioqsw"
  ];

  meta = with lib; {
    description = "Library to fetch data from QNAP QSW switches";
    homepage = "https://github.com/Noltari/aioqsw";
    changelog = "https://github.com/Noltari/aioqsw/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
