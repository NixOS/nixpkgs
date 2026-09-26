{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  h11,
  maxminddb,
  pytestCheckHook,
  requests-mock,
  pytest-httpserver,
  requests,
  setuptools-scm,
  uv-build,
  urllib3,
}:

buildPythonPackage rec {
  pname = "geoip2";
  version = "5.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bJ3tGVP46xYEPtCo6iDm6VJOp7Zet0VyThJJCspE7wA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.7.19,<0.8.0" uv_build
  '';

  build-system = [
    uv-build
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

  meta = {
    description = "GeoIP2 webservice client and database reader";
    homepage = "https://github.com/maxmind/GeoIP2-python";
    changelog = "https://github.com/maxmind/GeoIP2-python/blob/v${version}/HISTORY.rst";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
