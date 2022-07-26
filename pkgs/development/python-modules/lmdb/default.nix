{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, cffi
, lmdb
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "60a11efc21aaf009d06518996360eed346f6000bfc9de05114374230879f992e";
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
