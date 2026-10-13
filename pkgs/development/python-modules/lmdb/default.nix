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
  version = "3.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-Bt2gcjVF4U1WrH3Nb1gtmSLC7V4W8cP40OZwqW7C7mU=";
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
