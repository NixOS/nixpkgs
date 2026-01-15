{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiotedee";
  version = "0.2.25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zweckj";
    repo = "aiotedee";
    tag = "v${version}";
    hash = "sha256-xVZrXKJXQd+Jklka+LGA/q+vgQqsVH+prboM6G3CWWg=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "aiotedee" ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Module to interact with Tedee locks";
    homepage = "https://github.com/zweckj/aiotedee";
    changelog = "https://github.com/zweckj/aiotedee/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
