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
  version = "3.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "6c79b87f2fefcf47bbcebea56056d324e9d7971c9b98123b79590e08cbb0a8f7";
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
