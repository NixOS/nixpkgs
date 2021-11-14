{ lib, buildPythonPackage, fetchPypi
, aiohttp, pytest, pytest-cov, pytest-aiohttp
}:

buildPythonPackage rec {
  pname = "aiohttp_remotes";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e44f2c5fd5fc3305477c89bb25f14570589100cc58c48b36745d4239839d3174";
  };

  propagatedBuildInputs = [ aiohttp ];

  checkInputs = [ pytest pytest-cov pytest-aiohttp ];
  checkPhase = ''
    python -m pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/wikibusiness/aiohttp-remotes";
    description = "A set of useful tools for aiohttp.web server";
    license = licenses.mit;
    maintainers = [ maintainers.qyliss ];
  };
}
