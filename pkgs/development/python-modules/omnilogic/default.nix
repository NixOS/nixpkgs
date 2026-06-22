{
  lib,
  aiohttp,
  xmltodict,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "omnilogic";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "djtimca";
    repo = "omnilogic-api";
    tag = version;
    hash = "sha256-ySK2T5T+Qdq8nVQqluIARR89KmM1N3oD44oLydwcs7E=";
  };

  propagatedBuildInputs = [
    aiohttp
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "omnilogic" ];

  meta = {
    description = "Python interface for the Hayward Omnilogic pool control system";
    homepage = "https://github.com/djtimca/omnilogic-api";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
