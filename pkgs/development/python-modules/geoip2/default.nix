{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  h11,
  maxminddb,
  mocket,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests-mock,
  pytest-httpserver,
  requests,
  setuptools-scm,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "geoip2";
  version = "4.8.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-muouq0s+YlL0dFZSiunDWxBMRSd2OcE/zhvofJL4Qlc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    aiohttp
    maxminddb
    requests
    urllib3
  ];

  nativeCheckInputs = [
    h11
    mocket
    requests-mock
    pytestCheckHook
    pytest-httpserver
  ];

  pythonImportsCheck = [ "geoip2" ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.10") [
      # https://github.com/maxmind/GeoIP2-python/pull/136
      "TestAsyncClient"
    ]
    ++ lib.optionals (pythonAtLeast "3.10") [ "test_request" ];

  meta = with lib; {
    description = "GeoIP2 webservice client and database reader";
    homepage = "https://github.com/maxmind/GeoIP2-python";
    changelog = "https://github.com/maxmind/GeoIP2-python/blob/v${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
