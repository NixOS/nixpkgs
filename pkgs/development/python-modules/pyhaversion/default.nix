{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, aiohttp
, async-timeout
, semantic-version
, pytestrunner
}:
buildPythonPackage rec {
  pname = "pyhaversion";
  version = "3.4.2";
  disabled = pythonOlder "3.8";

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

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "pyhaversion" ];

  meta = with lib; {
    description = "A python module to the newest version number of Home Assistant";
    homepage = "https://github.com/ludeeus/pyhaversion";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.makefu ];
  };
}
