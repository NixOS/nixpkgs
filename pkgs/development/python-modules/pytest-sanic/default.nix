{ lib
, buildPythonPackage
, fetchPypi
, pytest
, aiohttp
, async_generator
}:

buildPythonPackage rec {
  pname = "pytest-sanic";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0vlaq6p9g2p1xj9wshmin58p1faf5h9rcxvmjapx26zv8n23rnm1";
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
