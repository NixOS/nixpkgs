{ stdenv
, buildPythonPackage
, fetchPypi
, redis
, python
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "aa59dd63bb3f736de4fc2d080114429d5d369dfb3265f771778e8349d67a97a4";
  };
  propagatedBuildInputs = [ redis ];

  checkPhase = ''
    ${python.interpreter} test.py
  '';

  meta = with stdenv.lib; {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

