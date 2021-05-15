{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, dask
, distributed
}:

buildPythonPackage rec {
  pname = "dask-gateway";
  # update dask-gateway lock step with dask-gateway-server
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "743f3b88dabe7d1503ac08aadf399eb9205df786b12c5175ea2e10c6ded7df22";
  };

  propagatedBuildInputs = [
    aiohttp
    dask
    distributed
  ];

  # tests requires cluster for testing
  doCheck = false;

  pythonImportsCheck = [ "dask_gateway" ];

  meta = with lib; {
    description = "A client library for interacting with a dask-gateway server";
    homepage = "https://gateway.dask.org/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
