{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "property-cached";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "althonos";
    repo = "property-cached";
    tag = "v${version}";
    hash = "sha256-8kityZ++1TS22Ff7a5x5bQi0QBaHsNaP4E/Man8A28A=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    freezegun
  ];

  disabledTestPaths = [
    # https://github.com/althonos/property-cached/pull/118
    "tests/test_coroutine_cached_property.py"
    "tests/test_async_cached_property.py"
  ];
  disabledTests = [
    # https://github.com/pydanny/cached-property/issues/131
    "test_threads_ttl_expiry"
  ];

  pythonImportsCheck = [ "property_cached" ];

  meta = {
    description = "Decorator for caching properties in classes";
    homepage = "https://github.com/althonos/property-cached";
    changelog = "https://github.com/althonos/property-cached/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jherland ];
  };
}
