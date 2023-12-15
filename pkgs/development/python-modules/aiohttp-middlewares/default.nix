{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, aiohttp
, async-timeout
, yarl
}:

buildPythonPackage rec {
  pname = "aiohttp-middlewares";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "aiohttp_middlewares";
    inherit version;
    hash = "sha256-CGdkAYWKbIdT4CBc049RAaTDXsHCROu2BhYgU74bNXI=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    yarl
  ];

  pythonImportsCheck = [ "aiohttp_middlewares" ];

  meta = with lib; {
    description = "Collection of useful middlewares for aiohttp applications";
    homepage = "https://pypi.org/project/aiohttp-middlewares/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
