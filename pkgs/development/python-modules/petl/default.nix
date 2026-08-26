{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "petl";
  version = "1.7.24";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "petl-developers";
    repo = "petl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0YIaA/0VaQ1dgKC0NrLTkAsn8kkEHIJ4W9sdZHYQeMM=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "petl" ];

  meta = {
    homepage = "https://github.com/petl-developers/petl";
    changelog = "https://github.com/petl-developers/petl/releases/tag/${finalAttrs.src.tag}";
    description = "Python package for extracting, transforming and loading tables of data";
    license = lib.licenses.mit;
    mainProgram = "petl";
    maintainers = with lib.maintainers; [
      alapshin
    ];
  };
})
