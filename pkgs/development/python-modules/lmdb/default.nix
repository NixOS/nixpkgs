{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
  cffi,
  lmdb,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.6.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0o4/pZk1/2iIWHYOxS8gLsuMEImj9o0fFi6jB40VHnM=";
  };

  build-system = [ setuptools ];

  buildInputs = [ lmdb ];

  pythonImportsCheck = [ "lmdb" ];

  nativeCheckInputs = [
    cffi
    pytestCheckHook
  ];

  LMDB_FORCE_SYSTEM = 1;

  meta = {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    changelog = "https://github.com/jnwatson/py-lmdb/blob/py-lmdb_${version}/ChangeLog";
    license = lib.licenses.openldap;
    maintainers = with lib.maintainers; [
      copumpkin
      ivan
    ];
  };
}
