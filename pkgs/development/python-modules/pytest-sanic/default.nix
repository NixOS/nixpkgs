{ lib
, buildPythonPackage
, fetchPypi
, pytest
, aiohttp
, async_generator
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "61a60e1b0456b2ceaeeb7173783f3450332c3609017fb6b18176b307f7186d3a";
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
    homepage = https://github.com/yunstanford/pytest-sanic/;
    license = licenses.asl20;
    maintainers = [ maintainers.costrouc ];
  };
}
