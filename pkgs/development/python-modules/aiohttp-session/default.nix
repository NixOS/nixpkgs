{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  aiohttp,

  # optional-dependencies
  aiomcache,
  cryptography,
  pynacl,
  redis,
}:

buildPythonPackage rec {
  pname = "aiohttp-session";
  version = "2.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-session";
    rev = "v${version}";
    hash = "sha256-7MNah4OIQnoxLoZkLOdeu5uCwSyPMhc6Wsht8dFconc=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  optional-dependencies = {
    aioredis = [ redis ];
    aiomcache = [ aiomcache ];
    pycrypto = [ cryptography ];
    secure = [ cryptography ];
    pynacl = [ pynacl ];
  };

  doCheck = false; # runs redis in docker

  pythonImportsCheck = [ "aiohttp_session" ];

  meta = with lib; {
    description = "Web sessions for aiohttp.web";
    homepage = "https://github.com/aio-libs/aiohttp-session";
    changelog = "https://github.com/aio-libs/aiohttp-session/blob/${src.rev}/CHANGES.txt";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
