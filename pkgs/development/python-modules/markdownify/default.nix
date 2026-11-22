{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "markdownify";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matthewwithanm";
    repo = "python-markdownify";
    tag = finalAttrs.version;
    hash = "sha256-CGVZDDkD2NGudvNBSrhfZBUIs6WnYSnDud+c+dQeUBo=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    beautifulsoup4
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "markdownify" ];

  meta = {
    description = "HTML to Markdown converter";
    homepage = "https://github.com/matthewwithanm/python-markdownify";
    changelog = "https://github.com/matthewwithanm/python-markdownify/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ McSinyx ];
    mainProgram = "markdownify";
  };
})
