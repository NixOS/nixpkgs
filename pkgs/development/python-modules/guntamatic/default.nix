{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "guntamatic";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JensTimmerman";
    repo = "guntamatic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AFqr2+N8uDpeUOvPuFZQbvln1sxWhrJEj31H2DOYX1k=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "guntamatic" ];

  meta = {
    description = "Module to get data from a Guntamatic heater e.g. BMK 20";
    homepage = "https://github.com/JensTimmerman/guntamatic";
    changelog = "https://github.com/JensTimmerman/guntamatic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
