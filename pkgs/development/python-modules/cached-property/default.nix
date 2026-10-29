{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  freezegun,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "cached-property";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydanny";
    repo = "cached-property";
    tag = version;
    hash = "sha256-sOThFJs18DR9aBgIpqkORU4iRmhCVKehyM3DLYUt/Wc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    freezegun
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/pydanny/cached-property/issues/131
    "test_threads_ttl_expiry"
  ];

  pythonImportsCheck = [ "cached_property" ];

  meta = {
    description = "Decorator for caching properties in classes";
    homepage = "https://github.com/pydanny/cached-property";
    changelog = "https://github.com/pydanny/cached-property/releases/tag/${version}";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
