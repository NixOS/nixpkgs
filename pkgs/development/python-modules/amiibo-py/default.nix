{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  aiohttp,
  requests,
}:

buildPythonPackage rec {
  pname = "amiibo-py";
  version = "unstable-2021-01-16";
  format = "setuptools";
  disabled = pythonOlder "3.5.3"; # Older versions are not supported upstream

  src = fetchFromGitHub {
    owner = "XiehCanCode";
    repo = "amiibo.py";
    rev = "4766037530f41ad11368240e994888d196783b83";
    sha256 = "0ln8ykaws8c5fvzlzccn60mpbdbvxlhkp3nsvs2xqdbsqp270yv2";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  doCheck = false; # No tests are available upstream
  pythonImportsCheck = [ "amiibo" ];

  meta = with lib; {
    description = "API Wrapper for amiiboapi.com";
    homepage = "https://github.com/XiehCanCode/amiibo.py";
    license = licenses.mit;
    maintainers = [ ];
  };
}
