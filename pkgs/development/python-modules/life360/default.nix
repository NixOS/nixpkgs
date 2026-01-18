{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "life360";
  version = "7.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pnbruckner";
    repo = "life360";
    tag = "v${version}";
    hash = "sha256-GkCs479lXcnCvb5guxyc+ZuZdiH4n8uD2VbkC+yijgg=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "life360" ];

  meta = {
    description = "Module to interact with Life360";
    homepage = "https://github.com/pnbruckner/life360";
    changelog = "https://github.com/pnbruckner/life360/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
