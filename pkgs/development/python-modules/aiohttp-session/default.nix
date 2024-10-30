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
  version = "2.12.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "aio-libs";
    repo = "aiohttp-session";
    rev = "refs/tags/v${version}";
    hash = "sha256-mGWtHo/+jdCmv3TmUUv42hWSiLzPiP5ytB25pVyvZig=";
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
