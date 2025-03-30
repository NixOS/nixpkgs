{
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  lib,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "livisi";
  version = "0.0.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "planbnet";
    repo = "livisi";
    tag = "v${version}";
    hash = "sha256-ggEbzN9FfqT968hgOblIh5dfVibzgUEc4SoZfBGOCwo=";
  };

  pythonRelaxDeps = [ "colorlog" ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    colorlog
    websockets
  ];

  pythonImportsCheck = [ "livisi" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Connection library for the abandoned Livisi Smart Home system";
    homepage = "https://github.com/planbnet/livisi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
