{ stdenv
, fetchFromGitHub
, buildPythonPackage
, redis, msgpack, channels, aioredis, async_generator, pytest
}:
buildPythonPackage rec {

  pname = "channels_redis";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "django";
    repo = pname;
    rev = version;
    sha256 = "05niaqjv790mnrvca26kbnvb50fgnk2zh0k4np60cn6ilp4nl0kc";
  };


  propagatedBuildInputs = [
    redis
    aioredis
    msgpack
    channels
  ];

  checkInputs = [ pytest async_generator ];
  checkPhase = ''
    # Ensure tests are running against installed packages.
    mv channels_redis channels_redis.hidden
    # test_double_receive expects a redis server running.
    pytest tests/ -k "not test_double_receive"
  '';

  meta = with stdenv.lib; {
    homepage = "http://github.com/django/channels_redis";
    license = licenses.bsdOriginal;
    description = "A Django Channels channel layer that uses Redis as its backing store";
    maintainers = with maintainers; [ BadDecisionsAlex ];
  };

}
