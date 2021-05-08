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
  version = "3.0.4";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "arraylabs";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jeoFlLBjD81Bt6E75rk4U1Ach53KGy23QGx+A6X2rpg=";
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
