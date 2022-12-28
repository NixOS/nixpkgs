{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# tested using
, python
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81d6d8e39695f2c37954d1011c0480ef7cf444d4e3ae24bc5e89ee5de360139a";
  };

  pythonImportsCheck = [ "hiredis" ];

  checkPhase = ''
    mv hiredis _hiredis
    ${python.interpreter} test.py
  '';

  meta = with lib; {
    description = "Wraps protocol parsing code in hiredis, speeds up parsing of multi bulk replies";
    homepage = "https://github.com/redis/hiredis-py";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}

