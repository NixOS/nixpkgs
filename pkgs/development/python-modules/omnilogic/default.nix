{ lib
, aiohttp
, xmltodict
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "omnilogic";
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "omnilogic-api";
    rev = "refs/tags/${version}";
    hash = "sha256-ySK2T5T+Qdq8nVQqluIARR89KmM1N3oD44oLydwcs7E=";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "omnilogic"
  ];

  meta = with lib; {
    description = "Python interface for the Hayward Omnilogic pool control system";
    homepage = "https://github.com/djtimca/omnilogic-api";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
