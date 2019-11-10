{ stdenv
, buildPythonPackage
, fetchPypi
, redis
, python
}:

buildPythonPackage rec {
  pname = "hiredis";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "158pymdlnv4d218w66i8kzdn4ka30l1pdwa0wyjh16bj10zraz79";
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

