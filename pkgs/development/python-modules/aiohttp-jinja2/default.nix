{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, jinja2
, pytest-aiohttp
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o6f/UmTlvKUuiuVHu/0HYbcklSMNQ40FtsCRW+YZsOI=";
  };

  propagatedBuildInputs = [
    aiohttp
    jinja2
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace " --cov=aiohttp_jinja2 --cov-report xml --cov-report html --cov-report term" ""
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "aiohttp_jinja2"
  ];

  # Tests are outdated (1.5)
  # pytest.PytestUnhandledCoroutineWarning: async def functions...
  doCheck = false;

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp_jinja2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
