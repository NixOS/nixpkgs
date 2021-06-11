{ lib
, aiohttp
, async-timeout
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytz
}:

buildPythonPackage rec {
  pname = "pydelijn";
  version = "0.6.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lwd2f043hy7gf1ly9zpaq1yg947bqw2af8vhwssf48zpisfgc81";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    pytz
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pydelijn" ];

  meta = with lib; {
    description = "Python package to retrieve realtime data of passages at stops of De Lijn";
    homepage = "https://github.com/bollewolle/pydelijn";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
