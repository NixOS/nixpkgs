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
  version = "3.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06f28f63bf4ea3d739ff5c472e76563e24aa5c887002a85cbdb7a5b13aa05897";
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
