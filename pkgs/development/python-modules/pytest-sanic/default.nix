{ lib
, buildPythonPackage
, fetchPypi
, pytest
, aiohttp
, async_generator
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.6.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "99e02c28cfa18a0a9af0cd151dddf0eca373279b9bac808733746f7ed7030ecc";
  };

  propagatedBuildInputs = [
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
