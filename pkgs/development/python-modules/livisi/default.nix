{
  aiohttp,
  buildPythonPackage,
  colorlog,
  fetchFromGitHub,
  lib,
  python-dateutil,
  setuptools,
  websockets,
}:

buildPythonPackage rec {
  pname = "livisi";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "planbnet";
    repo = "livisi";
    tag = "v${version}";
    hash = "sha256-VgX4x8goE4pAkbaTOSljbJGHEEfsl56XACpEkYjZjR4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    colorlog
    python-dateutil
    websockets
  ];

  pythonImportsCheck = [ "livisi" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/planbnet/livisi/releases/tag/${src.tag}";
    description = "Connection library for the abandoned Livisi Smart Home system";
    homepage = "https://github.com/planbnet/livisi";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
