{ lib
, aiohttp
, xmltodict
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "omnilogic";
  version = "0.4.9";

  disabled = pythonOlder "3.4";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "omnilogic-api";
    rev = "refs/tags/${version}";
    hash = "sha256-U+3FI/2qLuPayURP8V+SGuIQK14FWGOgJtpJnmsmulA=";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "omnilogic" ];

  meta = with lib; {
    description = "Python interface for the Hayward Omnilogic pool control system";
    homepage = "https://github.com/djtimca/omnilogic-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
