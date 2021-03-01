{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, async-timeout
}:

buildPythonPackage rec {
  pname = "netdata";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14kyjp1q3clizs1bqx4rp31d2awjmi5v65z8sarr2ycgwqqmkrzw";
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
