{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  maxminddb,
  mocket,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  requests,
  requests-mock,
  urllib3,
}:

buildPythonPackage rec {
  pname = "geoip2";
  version = "4.8.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3ZzBgLfUFyQkDqSB1dU5FJ5lsjT2QoKyMbkXB5SprDU=";
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
    mocket
    requests-mock
    pytestCheckHook
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
