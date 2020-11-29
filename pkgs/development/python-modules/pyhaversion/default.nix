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
  version = "3.4.2";

  # needs aiohttp which is py3k-only
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b4e49dfa0f9dae10edd072e630d902e5497daa312baad58b7df7618efe863377";
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
