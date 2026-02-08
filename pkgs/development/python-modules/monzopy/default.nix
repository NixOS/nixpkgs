{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "monzopy";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JakeMartin-ICL";
    repo = "monzopy";
    tag = "v${version}";
    hash = "sha256-LMg3hCaNa9LF3pZEQ/uQgt81V6qKmOwZnKHdsI8MHLY=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "monzopy" ];

  meta = {
    description = "Module to work with the Monzo API";
    homepage = "https://github.com/JakeMartin-ICL/monzopy";
    changelog = "https://github.com/JakeMartin-ICL/monzopy/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
