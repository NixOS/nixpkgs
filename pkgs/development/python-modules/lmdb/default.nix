{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, cffi
}:

buildPythonPackage rec {
  pname = "lmdb";
  version = "0.96";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0wpahad7wac34r1hxa1jhk0bsll39n7667cljyr5251kj12ksfgr";
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
