{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "locate";
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AutoActuary";
    repo = "locate";
    tag = finalAttrs.version;
    hash = "sha256-cPBxSjcX0y0Ul7B6yOY+U2ylrQ1oBV6t3lN4qyutGlE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "locate" ];

  meta = {
    description = "Locate files relative to the current Python script";
    homepage = "https://github.com/AutoActuary/locate";
    changelog = "https://github.com/AutoActuary/locate/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.geri1701 ];
  };
})
