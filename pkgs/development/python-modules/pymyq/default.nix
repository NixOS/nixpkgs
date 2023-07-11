{ lib
, aiohttp
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, pkce
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymyq";
  version = "3.1.6";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "arraylabs";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zhGCoZ7mkHlfDjEbQihtM23u+N6nfYsQhKmrloevzp8=";
  };

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
    homepage = "https://github.com/arraylabs/pymyq";
    changelog = "https://github.com/arraylabs/pymyq/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
