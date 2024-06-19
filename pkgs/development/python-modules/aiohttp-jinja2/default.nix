{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  jinja2,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohttp-jinja2";
  version = "1.6";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o6f/UmTlvKUuiuVHu/0HYbcklSMNQ40FtsCRW+YZsOI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    jinja2
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pytest.ini \
      --replace-fail "--cov=aiohttp_jinja2/ --cov=tests/ --cov-report term" ""
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [ "aiohttp_jinja2" ];

  meta = with lib; {
    description = "Jinja2 support for aiohttp";
    homepage = "https://github.com/aio-libs/aiohttp_jinja2";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
