{ lib
, aioredis
, asgiref
, buildPythonPackage
, channels
, fetchPypi
, hiredis
, msgpack
, pythonOlder
, redis
}:

buildPythonPackage rec {
  pname = "channels-redis";
  version = "3.2.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "channels_redis";
    sha256 = "1rjs9irnq59yr6zwc9k6nnw6xrmr48dakrm25m0gcwskn1iimcrg";
  };

  buildInputs = [ redis hiredis ];

  propagatedBuildInputs = [ channels msgpack aioredis asgiref ];

  # Fails with : ConnectionRefusedError: [Errno 111] Connect call failed ('127.0.0.1', 6379)
  # (even with a local Redis instance running)
  doCheck = false;

  postPatch = ''
    sed -i "s/msgpack~=0.6.0/msgpack/" setup.py
    sed -i "s/aioredis~=1.0/aioredis/" setup.py
  '';

  pythonImportsCheck = [ "channels_redis" ];

  meta = with lib; {
    homepage = "https://github.com/django/channels_redis/";
    description = "Redis-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
