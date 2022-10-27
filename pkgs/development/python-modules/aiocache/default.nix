{ lib
, aioredis
, buildPythonPackage
, fetchFromGitHub
, msgpack
}:

buildPythonPackage rec {
  pname = "aiocache";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = pname;
    rev = version;
    sha256 = "1czs8pvhzi92qy2dch2995rb62mxpbhd80dh2ir7zpa9qcm6wxvx";
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
