{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  glibcLocales,
  importlib-metadata,
  packaging,
  htslib,
  fsspec,
  pytestCheckHook,
  biopython,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyfaidx";
  version = "0.9.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdshw5";
    repo = "pyfaidx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ewlOW41XU7EwggJ7/WDFW/zptDm97zThYPcAFWOFRuA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    importlib-metadata
    packaging
  ];

  nativeCheckInputs = [
    pytestCheckHook
    biopython
    htslib
    fsspec
    glibcLocales
  ];

  pythonImportsCheck = [ "pyfaidx" ];

  # Require a network access to download test files
  doCheck = false;

  meta = {
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    homepage = "https://github.com/mdshw5/pyfaidx";
    changelog = "https://github.com/mdshw5/pyfaidx/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jbedo ];
    mainProgram = "faidx";
  };
})
