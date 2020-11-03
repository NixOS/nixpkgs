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
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "519818f3598ddd726882c5a6bf7053941613d8517b80e8a2c28467e30d57da9b";
  };

  requiredPythonModules = [
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
