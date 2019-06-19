{ stdenv
, fetchPypi
, buildPythonPackage
, python
}:
buildPythonPackage rec {

  pname = "hiredis";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e97c953f08729900a5e740f1760305434d62db9f281ac351108d6c4b5bf51795";
  };
  
  checkPhase = "${python.interpreter} test.py";

  meta = with stdenv.lib; {
    homepage = "http://github.com/redis/hiredis-py";
    license = licenses.bsdOriginal;
    description = "Python extension that wraps protocol parsing code in hiredis. It primarily speeds up parsing of multi bulk replies.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
