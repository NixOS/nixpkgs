{ stdenv
, buildPythonPackage
, fetchPypi
, redis
, python
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "996021ef33e0f50b97ff2d6b5f422a0fe5577de21a8873b58a779a5ddd1c3132";
  };
  propagatedBuildInputs = [ redis ];

  checkPhase = ''
    mv hiredis _hiredis
    ${python.interpreter} test.py
  '';
  pythonImportsCheck = [ "hiredis" ];

  meta = with stdenv.lib; {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

