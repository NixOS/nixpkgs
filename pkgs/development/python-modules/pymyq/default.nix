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
  version = "3.1.4";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "arraylabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-B8CnyM0nQr8HWnD5toMd8A57j/UtnQ2aWys0netOAtA=";
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
