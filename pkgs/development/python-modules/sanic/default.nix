{ lib, buildPythonPackage, fetchPypi, doCheck ? true
, aiofiles, httptools, multidict, sanic-routing, ujson, uvloop, websockets
, pytestCheckHook, beautifulsoup4, gunicorn, uvicorn, sanic-testing
, pytest-benchmark, pytest-sanic, pytest-sugar, pytestcov
}:

buildPythonPackage rec {
  pname = "sanic";
  version = "21.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cbd12b9138b3ca69656286b0be91fff02b826e8cb72dd76a2ca8c5eb1288d8e";
  };

  postPatch = ''
    # Loosen dependency requirements.
    substituteInPlace setup.py \
      --replace '"pytest==5.2.1"' '"pytest"' \
      --replace '"gunicorn==20.0.4"' '"gunicorn"' \
      --replace '"pytest-sanic",' ""
    # Patch a request headers test to allow brotli encoding
    # (we build httpx with brotli support, upstream doesn't).
    substituteInPlace tests/test_headers.py \
      --replace "deflate\r\n" "deflate, br\r\n"
  '';

  propagatedBuildInputs = [
    sanic-routing httptools uvloop ujson aiofiles websockets multidict
  ];

  checkInputs = [
    sanic-testing gunicorn pytestcov beautifulsoup4 pytest-sanic pytest-sugar
    pytest-benchmark pytestCheckHook uvicorn
  ];

  inherit doCheck;

  disabledTests = [
    "test_gunicorn" # No "examples" directory in pypi distribution.
    "test_zero_downtime" # No "examples.delayed_response.app" module in pypi distribution.
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "sanic" ];

  meta = with lib; {
    description = "A microframework based on uvloop, httptools, and learnings of flask";
    homepage = "https://github.com/sanic-org/sanic/";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc AluisioASG ];
  };
}
