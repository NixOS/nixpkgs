{ stdenv
, buildPythonPackage
, fetchPypi
, redis
, pytest
, process-tests
, pkgs
, withDjango ? false, django_redis
}:

buildPythonPackage rec {
  pname = "python-redis-lock";
  version = "3.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e3ef458b9424daf35d587e69b63416a0c55ac46303f3aaff1bab4fe5a8f1e92";
  };

  checkInputs = [ pytest process-tests pkgs.redis ];

  checkPhase = ''
    pytest tests/
  '';

  propagatedBuildInputs = [ redis ]
  ++ stdenv.lib.optional withDjango django_redis;


  meta = with stdenv.lib; {
    homepage = "https://github.com/ionelmc/python-redis-lock";
    license = licenses.bsd2;
    description = "Lock context manager implemented via redis SETNX/BLPOP";
    maintainers = with maintainers; [ vanschelven ];
  };
}
