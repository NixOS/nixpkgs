{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
}:

buildPythonPackage rec {
  pname = "pybravia";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Drafteed";
    repo = "pybravia";
    tag = "v${version}";
    hash = "sha256-Wx+YEEVZB0aGhgaQiC04GKwTY4yV0wj86b/8EJBs5yc=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pybravia" ];

  meta = {
    description = "Library for remote control of Sony Bravia TVs 2013 and newer";
    homepage = "https://github.com/Drafteed/pybravia";
    changelog = "https://github.com/Drafteed/pybravia/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
