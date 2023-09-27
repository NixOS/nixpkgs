{ lib
, aiohttp
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, pkce
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymyq";
  version = "3.1.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Python-MyQ";
    repo = "Python-MyQ";
    rev = "refs/tags/v${version}";
    hash = "sha256-7fGm7VGE9D6vmQkNmiB52+il3GE/rTqTqxqAORy88l4=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    pkce
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pymyq"
  ];

  meta = with lib; {
    description = "Python wrapper for MyQ API";
    homepage = "https://github.com/Python-MyQ/Python-MyQ";
    changelog = "https://github.com/Python-MyQ/Python-MyQ/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
