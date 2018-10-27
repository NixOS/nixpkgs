{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.92";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01nw6r08jkipx6v92kw49z34wmwikrpvc5j9xawdiyg1n2526wrx";
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
