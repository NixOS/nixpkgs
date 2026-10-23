{
  lib,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfastnoiselite-ledfx";
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LedFx";
    repo = "pyfastnoiselite-ledfx";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FbE1nlCrMVEJZkWvPUtuz0MnDkQHEwCN5NUS2aNj8ic=";
  };

  build-system = [
    cython
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyfastnoiselite" ];

  meta = {
    description = "Wrapper for Auburns' FastNoise Lite noise generation library";
    homepage = "https://github.com/LedFx/pyfastnoiselite-ledfx";
    changelog = "https://github.com/LedFx/pyfastnoiselite-ledfx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
})
