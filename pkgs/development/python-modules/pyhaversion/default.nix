{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
# propagatedBuildInputs
, aiohttp
, async-timeout
, semantic-version
# buildInputs
, pytestrunner
# checkInputs
, pytest
, pytest-asyncio
, aresponses
}:
buildPythonPackage rec {
  pname = "pyhaversion";
  version = "3.3.0";

  # needs aiohttp which is py3k-only
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "376a1b232a26035bc82d64affa1c4f312d782234fe5453e8d0f9e1350a97be5b";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    semantic-version
  ];

  buildInputs = [
    pytestrunner
  ];

  checkInputs = [
    pytest
    pytest-asyncio
    aresponses
  ];

  meta = with lib; {
    description = "A python module to the newest version number of Home Assistant";
    homepage = "https://github.com/ludeeus/pyhaversion";
    maintainers = [ maintainers.makefu ];
  };
}
