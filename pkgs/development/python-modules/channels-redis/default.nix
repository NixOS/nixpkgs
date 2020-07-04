{ stdenv, buildPythonPackage, fetchPypi, pythonOlder
, redis, channels, msgpack, aioredis, hiredis, asgiref
# , fetchFromGitHub, async_generator, async-timeout, cryptography, pytest, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "channels-redis";
  version = "2.4.0";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit version;
    pname = "channels_redis";
    sha256 = "1g4izdf8237pwxn85bv5igc2bajrvck1p2a7q448qmjfznrbrk5p";
  };

  buildInputs = [ redis hiredis ];

  propagatedBuildInputs = [ channels msgpack aioredis asgiref ];

  # Fetch from github (no tests files on pypi)
  # src = fetchFromGitHub {
  #   rev = version;
  #   owner = "django";
  #   repo = "channels_redis";
  #   sha256 = "05niaqjv790mnrvca26kbnvb50fgnk2zh0k4np60cn6ilp4nl0kc";
  # };
  #
  # checkInputs = [
  #   async_generator
  #   async-timeout
  #   cryptography
  #   pytest
  #   pytest-asyncio
  # ];
  # 
  # # Fails with : ConnectionRefusedError: [Errno 111] Connect call failed ('127.0.0.1', 6379)
  # # (even with a local redis instance running)
  # checkPhase = ''
  #   pytest -p no:django tests/
  # '';

  postPatch = ''
    sed -i "s/msgpack~=0.6.0/msgpack/" setup.py
    sed -i "s/aioredis~=1.0/aioredis/" setup.py
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/django/channels_redis/";
    description = "Redis-backed ASGI channel layer implementation";
    license = licenses.bsd3;
    maintainers = with maintainers; [ mmai ];
  };
}
