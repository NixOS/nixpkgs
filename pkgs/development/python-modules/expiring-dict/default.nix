{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  sortedcontainers,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "expiring-dict";
  version = "1.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "expiring_dict";
    inherit (finalAttrs) version;
    hash = "sha256-yoy4AjBOrlszoj7EwZAZthCt/aUMvEyb+jrVws04djE=";
  };

  build-system = [ setuptools ];

  dependencies = [ sortedcontainers ];

  pythonImportsCheck = [ "expiring_dict" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky real-time assertions: https://github.com/dparker2/py-expiring-dict/issues/5
    "test_class_ttl"
    "test_set_ttl"
    "test_class_ttl_twice"
    "test_class_reset_ttl_with_reinsert"
    "test_class_ttl_reinsert_after_delete"
  ];

  meta = {
    description = "Python dict with TTL support for auto-expiring caches";
    homepage = "https://github.com/dparker2/py-expiring-dict";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
