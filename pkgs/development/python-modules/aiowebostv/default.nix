{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiowebostv";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiowebostv";
    tag = "v${version}";
    hash = "sha256-9wDXVvlRsQ53U6tnqaR+SspCcSSh8Zuk651DZaL/s1o=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "aiowebostv" ];

  meta = {
    description = "Module to interact with LG webOS based TV devices";
    homepage = "https://github.com/home-assistant-libs/aiowebostv";
    changelog = "https://github.com/home-assistant-libs/aiowebostv/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
