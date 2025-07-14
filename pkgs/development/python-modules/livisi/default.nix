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
  version = "0.0.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "planbnet";
    repo = "livisi";
    tag = "v${version}";
    hash = "sha256-kEkbuZmYzxhrbTdo7eZJYu2N2uJtfspgqepplXvSXFg=";
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
