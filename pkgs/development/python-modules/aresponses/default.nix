{ lib
, buildPythonPackage
, fetchPypi
# propagatedBuildInputs
, aiohttp
# buildInputs
, pytest
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "aresponses";
  version = "1.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "20a63536d86af6f31f9b0720c561bdc595b6bfe071940e347ab58b11caff9e1b";
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
