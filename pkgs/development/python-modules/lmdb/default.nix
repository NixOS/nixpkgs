{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  patch-ng,
  pytestCheckHook,
  cffi,
  lmdb,
}:

buildPythonPackage (finalAttrs: {
  pname = "lmdb";
  version = "2.2.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-sgG0FvfWzqm9L5dyd6X1HW5SpDTW7FEaizSZDfKxqcU=";
  };

  build-system = [ setuptools ];

  buildInputs = [ lmdb ];

  nativeBuildInputs = [ cffi ];

  env.LMDB_FORCE_SYSTEM = 1;

  dependencies = [ patch-ng ];

  pythonImportsCheck = [ "lmdb" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    changelog = "https://github.com/jnwatson/py-lmdb/blob/py-lmdb_${finalAttrs.version}/ChangeLog";
    license = lib.licenses.openldap;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
})
