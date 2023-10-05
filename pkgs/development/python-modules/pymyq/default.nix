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
  version = "3.1.11";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Python-MyQ";
    repo = "Python-MyQ";
    rev = "refs/tags/v${version}";
    hash = "sha256-hQnIrmt4CNxIL2+VenGaKL6xMOb/6IMq9NEFLvbbYsE=";
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
