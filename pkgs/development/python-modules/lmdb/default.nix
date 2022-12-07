{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, cffi
, lmdb
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OfbE7hRdKNFwJdNQcgq7b5XbgWUU6GjbV0RP3vUcu0c=";
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
