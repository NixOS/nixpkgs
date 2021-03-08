{ lib, buildPythonPackage, fetchPypi
, aiofiles, httptools, httpx, multidict, ujson, uvloop, websockets
, pytestCheckHook, beautifulsoup4, gunicorn, httpcore, uvicorn
, pytest-asyncio, pytest-benchmark, pytest-dependency, pytest-sanic, pytest-sugar, pytestcov
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "20.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06p0lsxqbfbka2yaqlpp0bg5pf7ma44zi6kq7qbb6hhry48dp1w6";
  };

  patchPhase = ''
    substituteInPlace setup.py \
      --replace '"multidict==5.0.0"' '"multidict"' \
      --replace '"httpx==0.15.4"' '"httpx"' \
      --replace '"httpcore==0.3.0"' '"httpcore"' \
      --replace '"pytest==5.2.1"' '"pytest"'
  '';

  propagatedBuildInputs = [
    aiofiles httptools httpx multidict ujson uvloop websockets
  ];

  checkInputs = [
    pytestCheckHook beautifulsoup4 gunicorn httpcore uvicorn
    pytest-asyncio pytest-benchmark pytest-dependency pytest-sanic pytest-sugar pytestcov
  ];

  disabledTests = [
    "test_gunicorn" # No "examples" directory in pypi distribution.
    "test_logo" # Fails to filter out "DEBUG asyncio:selector_events.py:59 Using selector: EpollSelector"
    "test_zero_downtime" # No "examples.delayed_response.app" module in pypi distribution.
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A microframework based on uvloop, httptools, and learnings of flask";
    homepage = "http://github.com/channelcat/sanic/";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
  };
}
