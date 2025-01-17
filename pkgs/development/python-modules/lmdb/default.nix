{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  cffi,
  lmdb,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-0o4/pZk1/2iIWHYOxS8gLsuMEImj9o0fFi6jB40VHnM=";
  };

  buildInputs = [ lmdb ];

  nativeCheckInputs = [
    cffi
    pytestCheckHook
  ];

  LMDB_FORCE_SYSTEM = 1;

  meta = with lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    changelog = "https://github.com/jnwatson/py-lmdb/blob/py-lmdb_${version}/ChangeLog";
    license = licenses.openldap;
    maintainers = with maintainers; [
      copumpkin
      ivan
    ];
  };
}
