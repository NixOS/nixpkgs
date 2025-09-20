{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  patch-ng,
  pytestCheckHook,
  cffi,
  lmdb,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.7.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1KJ7evT+OPNAnZ+/v0e2F7PZTe6YoAvIwqgzbM0/mxU=";
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
    changelog = "https://github.com/jnwatson/py-lmdb/blob/py-lmdb_${version}/ChangeLog";
    license = lib.licenses.openldap;
    maintainers = with lib.maintainers; [
      ivan
    ];
  };
}
