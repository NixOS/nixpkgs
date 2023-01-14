{ lib
, aioredis
, buildPythonPackage
, fetchFromGitHub
, msgpack
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-jNfU5jT2xLgwVeVp8jXrQ6QQuUDwMOxf+hZ7VFsMFpM=";
  };

  propagatedBuildInputs = [
    aioredis
    msgpack
  ];

  # aiomcache would be required but last release was in 2017
  doCheck = false;
  pythonImportsCheck = [ "aiocache" ];

  meta = with lib; {
    description = "Python API Rate Limit Decorator";
    homepage = "https://github.com/tomasbasham/ratelimit";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
