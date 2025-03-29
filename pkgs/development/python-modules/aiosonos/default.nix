{
  lib,
  aiohttp,
  orjson,
  faust-cchardet,
  aiodns,
  brotli,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiosonos";
  version = "0.1.9";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "aiosonos";
    tag = version;
    hash = "sha256-15zGeYspuWR5w1yGHXfXhmUeV4p+/jhXrnkZ98XW/LI=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    faust-cchardet
    aiodns
    brotli
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "aiosonos"
    "aiosonos.api"
  ];

  meta = {
    description = "Async python library to communicate with Sonos devices ";
    homepage = "https://github.com/music-assistant/aiosonos";
    changelog = "https://github.com/music-assistant/aiosonos/releases/tag/${version}";
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.autrimpo ];
  };
}
