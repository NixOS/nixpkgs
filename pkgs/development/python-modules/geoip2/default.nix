{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  h11,
  maxminddb,
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
  version = "5.1.0";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7j+H8M6TJetkhP4Yy9l3GgPQorrR3RVvo1hPr6Vi05o=";
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
