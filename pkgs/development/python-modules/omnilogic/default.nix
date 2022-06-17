{ lib
, aiohttp
, xmltodict
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "omnilogic";
  version = "0.4.6";

  disabled = pythonOlder "3.4";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "omnilogic-api";
    rev = version;
    hash = "sha256-XyAniuUr/Kt8VfBtovD4kKLG+ehOqE26egEG7j8q9LY=";
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
