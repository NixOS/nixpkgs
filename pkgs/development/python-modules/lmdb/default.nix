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
  version = "2.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Jg9ENkDuLaPP0FmoQlhlkxn/OcqRLBa/l0jDJAdrnQk=";
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
  };
})
