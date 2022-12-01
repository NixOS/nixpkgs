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
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c5b6565c50d4f97d28baca9faf487281c2a5db635060b69f659e27c28a1a6e93";
  };

  propagatedBuildInputs = [
    aiohttp
    async-timeout
    pytz
  ];

  postPatch = ''
    # Remove with next release
    substituteInPlace setup.py \
      --replace "async_timeout>=3.0.1,<4.0" "async_timeout>=3.0.1"
    # https://github.com/bollewolle/pydelijn/pull/11
    substituteInPlace pydelijn/common.py \
      --replace ", loop=self.loop" ""
  '';

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pydelijn"
  ];

  meta = with lib; {
    description = "Python package to retrieve realtime data of passages at stops of De Lijn";
    homepage = "https://github.com/bollewolle/pydelijn";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
