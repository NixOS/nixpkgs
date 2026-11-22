{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  h11,
  maxminddb,
  pytest-httpserver,
  pytestCheckHook,
  requests-mock,
  requests,
  setuptools-scm,
  urllib3,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "geoip2";
  version = "5.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Zt9lPhbFNfm7RePHzpkvvgCJEdnHw0lUBXTqL+iTHbU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.26,<0.12.0" "uv_build"
  '';

  build-system = [
    uv-build
    setuptools-scm
  ];

  dependencies = [
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

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "GeoIP2 webservice client and database reader";
    homepage = "https://github.com/maxmind/GeoIP2-python";
    changelog = "https://github.com/maxmind/GeoIP2-python/blob/v${finalAttrs.version}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
