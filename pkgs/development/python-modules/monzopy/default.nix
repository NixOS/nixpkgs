{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "monzopy";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JakeMartin-ICL";
    repo = "monzopy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qCFOd+AVofRJ7xkatWVKOhf8V8riTEhrumkpX3HXUSw=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "monzopy" ];

  meta = {
    description = "Module to work with the Monzo API";
    homepage = "https://github.com/JakeMartin-ICL/monzopy";
    changelog = "https://github.com/JakeMartin-ICL/monzopy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
})
