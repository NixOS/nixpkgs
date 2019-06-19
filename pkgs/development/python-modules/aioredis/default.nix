{ stdenv
, fetchPypi
, buildPythonPackage
, hiredis, async-timeout
}:
buildPythonPackage rec {

  pname = "aioredis";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "84d62be729beb87118cf126c20b0e3f52d7a42bb7373dc5bcdd874f26f1f251a";
  };

  propagatedBuildInputs = [
    hiredis
    async-timeout
  ];

  # Tests rely on the presence of a redis server.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/django/channels_redis";
    license = licenses.mit;
    description = "asyncio (PEP 3156) Redis client library.";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
