{ stdenv
, fetchPypi
, buildPythonPackage
, redis, msgpack, channels, aioredis
}:
buildPythonPackage rec {

  pname = "channels_redis";
  version = "2.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7ccbcb2fd4e568c08c147891b26db59aa25d88b65af826ce7f70c815cfb91bc";
  };

  propagatedBuildInputs = [
    redis
    aioredis
    msgpack
    channels
  ];

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://github.com/django/channels_redis";
    license = licenses.bsdOriginal;
    description = "A Django Channels channel layer that uses Redis as its backing store";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
