{ lib
, buildPythonPackage
, fetchPypi
, redis
, python
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81d6d8e39695f2c37954d1011c0480ef7cf444d4e3ae24bc5e89ee5de360139a";
  };
  propagatedBuildInputs = [ redis ];

  checkPhase = ''
    mv hiredis _hiredis
    ${python.interpreter} test.py
  '';
  pythonImportsCheck = [ "hiredis" ];

  meta = with lib; {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

