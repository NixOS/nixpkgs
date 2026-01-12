{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  parameterized,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pypika";
  version = "0.49.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kayak";
    repo = "pypika";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Lawsc19sJ3U7rCOnYvDWhWqK/J+Hd3zKG6TrhDsTtVs=";
  };

  patches = [
    # Fix ast deprecation warnings, https://github.com/HENNGE/arsenic/pull/160
    (fetchpatch {
      name = "ast-deprecation.patch";
      url = "https://github.com/pyctrl/pypika/commit/e302e4d1c26242bcff61b50e0e8f157f181e1bc0.patch";
      hash = "sha256-pbJwOE5xaAapMKdm1xsNrISbCzHIKuhCgA2lA0vB1T8=";
    })
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    parameterized
    unittestCheckHook
  ];

  pythonImportsCheck = [ "pypika" ];

  meta = {
    description = "Python SQL query builder";
    homepage = "https://github.com/kayak/pypika";
    changelog = "https://github.com/kayak/pypika/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
