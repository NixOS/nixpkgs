{ lib
, buildPythonPackage
, fetchPypi
# propagatedBuildInputs
, aiohttp
, async-timeout
# buildInputs
, pytestrunner
# checkInputs
, pytest
, pytest-asyncio
, aresponses
}:
buildPythonPackage rec {
  pname = "pyhaversion";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d4smpzlaw0sqfgkgvhxsn8h7bmwj8h9gj98sdzvkzhp5vhd96b2";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
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
    homepage = https://github.com/ludeeus/pyhaversion;
    maintainers = [ maintainers.makefu ];
  };
}
