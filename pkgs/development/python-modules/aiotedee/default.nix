{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiotedee";
  version = "0.2.25";
  pyproject = true;

  disabled = pythonOlder "3.9";

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

  meta = with lib; {
    description = "Module to interact with Tedee locks";
    homepage = "https://github.com/zweckj/aiotedee";
    changelog = "https://github.com/zweckj/aiotedee/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
