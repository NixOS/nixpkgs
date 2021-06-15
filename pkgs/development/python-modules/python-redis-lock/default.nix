{ lib
, buildPythonPackage
, fetchPypi
, redis
, pytestCheckHook
, process-tests
, pkgs
, withDjango ? false, django_redis
}:

buildPythonPackage rec {
  pname = "python-redis-lock";
  version = "3.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4265a476e39d476a8acf5c2766485c44c75f3a1bd6cf73bb195f3079153b8374";
  };

  propagatedBuildInputs = [
    redis
  ] ++ lib.optional withDjango django_redis;

  checkInputs = [
    pytestCheckHook
    process-tests
    pkgs.redis
  ];

  disabledTests = [
    # https://github.com/ionelmc/python-redis-lock/issues/86
    "test_no_overlap2"
  ];

  meta = with lib; {
    homepage = "https://github.com/ionelmc/python-redis-lock";
    license = licenses.bsd2;
    description = "Lock context manager implemented via redis SETNX/BLPOP";
    maintainers = with maintainers; [ vanschelven ];
  };
}
