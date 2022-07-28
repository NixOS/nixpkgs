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
  version = "2022.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-i0OFXjvDg+D4Sdyg6rluP0k6/Ecr+VZn+RiIEQONQX0=";
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
