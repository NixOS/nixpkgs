{ lib
, buildPythonPackage
, fetchFromGitHub
, python
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4b3";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = pname;
    rev = version;
    sha256 = "1zjg475xgvi19rqg7jmfgy5nfabq50aph0231p9jba211ps7cmxw";
  };

  checkPhase = ''
    ${python.interpreter} -m aiocoap.cli.defaults
    ${python.interpreter} -m unittest discover -v
  '';

  pythonImportsCheck = [ "aiocoap" ];

  meta = with lib; {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
