{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, cffi
, lmdb
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5f76a90ebd08922acca11948779b5055f7a262687178e9e94f4e804b9f8465bc";
  };

  buildInputs = [ lmdb ];

  checkInputs = [ cffi pytestCheckHook ];

  LMDB_FORCE_SYSTEM=1;

  meta = with lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    license = licenses.openldap;
    maintainers = with maintainers; [ copumpkin ivan ];
  };
}
