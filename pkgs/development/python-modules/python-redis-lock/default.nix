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
  version = "3.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5316d473ce6ce86a774b9f9c110d84c3a9bd1a2abfda5d99e9c0c8a872a8e6d6";
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
