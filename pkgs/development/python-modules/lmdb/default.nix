{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.94";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zh38gvkqw1jm5105if6rr7ccbgyxr7k2rm5ygb9ab3bq82pyaww";
  };

  # Some sort of mysterious failure with lmdb.tool
  doCheck = !isPy3k;

  meta = with stdenv.lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    license = licenses.openldap;
    maintainers = with maintainers; [ copumpkin ];
  };

}
