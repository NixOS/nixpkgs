{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "aiosseclient";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ebraminio";
    repo = "aiosseclient";
    rev = version;
    hash = "sha256-T97HmO53w1zNpASPU+LRcnqtnQVqPWtlOXycpBw4WmY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Test requires network access
  doCheck = false;

  pythonImportsCheck = [ "aiosseclient" ];

  meta = {
    description = "Asynchronous Server Side Events (SSE) client";
    homepage = "https://github.com/ebraminio/aiosseclient";
    changelog = "https://github.com/ebraminio/aiosseclient/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
