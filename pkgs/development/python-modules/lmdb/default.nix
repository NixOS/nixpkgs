{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cffi
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.95";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nx9f193gzl33r1lbqhb96h1igya7pz8wmahr8m9x5zgc05hal91";
  };

  checkInputs = [ pytest cffi ];
  checkPhase = ''
    export PYTHONPATH=.:$PYTHONPATH
    py.test
  '';

  meta = with stdenv.lib; {
    description = "Universal Python binding for the LMDB 'Lightning' Database";
    homepage = "https://github.com/dw/py-lmdb";
    license = licenses.openldap;
    maintainers = with maintainers; [ copumpkin ];
  };

}
