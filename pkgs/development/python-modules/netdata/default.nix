{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "netdata";
  version = "0.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-oGOT4RvftI/2Ri2icM/AtglNZXt10jkFh/rlr6A46YE=";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "netdata" ];

  meta = with lib; {
    description = "Python API for interacting with Netdata";
    homepage = "https://github.com/home-assistant-ecosystem/python-netdata";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
