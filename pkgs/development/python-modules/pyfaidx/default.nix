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

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.9.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdshw5";
    repo = "pyfaidx";
    tag = "v${version}";
    hash = "sha256-R8k1h2FAlA/6eTJqH/Z2jHAyis2w5VDd1LcyE1hgbFc=";
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

  preCheck = ''
    bgzip --keep tests/data/genes.fasta
  '';

  meta = {
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    homepage = "https://github.com/mdshw5/pyfaidx";
    changelog = "https://github.com/mdshw5/pyfaidx/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jbedo ];
    mainProgram = "faidx";
  };
}
