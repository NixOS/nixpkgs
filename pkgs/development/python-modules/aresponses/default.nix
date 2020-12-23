{ lib
, buildPythonPackage
, fetchPypi
# propagatedBuildInputs
, aiohttp
# buildInputs
, pytest
, pytest-asyncio
, isPy3k
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "2.0.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca163c044165a6dd7c7c3df0f81661526c325ce34e3acc68c535b57945e04320";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  buildInputs = [
    pytest
    pytest-asyncio
  ];

  # tests only distributed via git repository, not pypi
  doCheck = false;

  meta = with lib; {
    description = "Asyncio testing server";
    homepage = "https://github.com/circleup/aresponses";
    license = licenses.mit;
    maintainers = [ maintainers.makefu ];
  };
}
