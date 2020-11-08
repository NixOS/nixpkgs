{ lib
, buildPythonPackage
, fetchPypi
, pytest
, aiohttp
, async_generator
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6428ed8cc2e6cfa05b92689a8589149aacdc1f0640fcf9673211aa733e6a5209";
  };

  requiredPythonModules = [
    pytest
    aiohttp
    async_generator
  ];

  # circular dependency on sanic
  doCheck = false;

  meta = with lib; {
    description = "A pytest plugin for Sanic";
    homepage = "https://github.com/yunstanford/pytest-sanic/";
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
