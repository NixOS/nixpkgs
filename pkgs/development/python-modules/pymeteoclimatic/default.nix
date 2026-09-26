{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  lxml,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pymeteoclimatic";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adrianmo";
    repo = "pymeteoclimatic";
    tag = finalAttrs.version;
    hash = "sha256-Yln+uUwnb5mlPS3uRRzpAH6kSc9hU2jEnhk/3ifiwWI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    beautifulsoup4
    lxml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "meteoclimatic" ];

  meta = {
    description = "Python wrapper around the Meteoclimatic service";
    homepage = "https://github.com/adrianmo/pymeteoclimatic";
    changelog = "https://github.com/adrianmo/pymeteoclimatic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
