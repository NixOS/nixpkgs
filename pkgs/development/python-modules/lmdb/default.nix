{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, cffi
, lmdb
, ludios_wpull
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "1.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "165cd1669b29b16c2d5cc8902b90fede15a7ee475c54d466f1444877a3f511ac";
  };

  buildInputs = [ lmdb ];

  propogatedBuildInputs = [ ludios_wpull ];

  checkInputs = [ cffi pytestCheckHook ];

  LMDB_FORCE_SYSTEM=1;

  meta = with lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    license = licenses.openldap;
    maintainers = with maintainers; [ copumpkin ivan ];
  };
}
