{ stdenv
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, cffi
, lmdb
, ludios_wpull
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4136ffdf0aad61da86d1402808029d002a771b2a9ccc9b39c6bcafa7847c21b6";
  };

  buildInputs = [ lmdb ];

  propogatedBuildInputs = [ ludios_wpull ];

  checkInputs = [ cffi pytestCheckHook ];

  LMDB_FORCE_SYSTEM=1;

  meta = with stdenv.lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    license = licenses.openldap;
    maintainers = with maintainers; [ copumpkin ivan ];
  };
}
