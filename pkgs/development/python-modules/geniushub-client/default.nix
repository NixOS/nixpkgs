{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "geniushub-client";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nNLiyQHx12vBcx5GJ4KsMVIe8m80BFcTh2ektHpMxYw=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # tests only implemented after 0.6.30
  doCheck = false;

  pythonImportsCheck = [ "geniushubclient" ];

  meta = with lib; {
    description = "Aiohttp-based client for Genius Hub systems";
    homepage = "https://github.com/zxdavb/geniushub-client";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
