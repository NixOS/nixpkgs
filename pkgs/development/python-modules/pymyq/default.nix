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
  version = "3.1.3";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "arraylabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-V2u2wUSPwiF6o6OWhQVKiHtzhn0/rzyM6e2+a+D7UNA=";
  };

  propagatedBuildInputs = [
    aiohttp
    beautifulsoup4
    pkce
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pymyq" ];

  meta = with lib; {
    description = "Python wrapper for MyQ API";
    homepage = "https://github.com/arraylabs/pymyq";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
