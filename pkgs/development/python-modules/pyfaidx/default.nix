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
  version = "0.8.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mdshw5";
    repo = "pyfaidx";
    rev = "refs/tags/v${version}";
    hash = "sha256-PKcopIu/0ko4Jl2+G0ZivZXvMwACeIFFFlPt5dlDDfQ=";
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
    changelog = "https://github.com/mdshw5/pyfaidx/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jbedo ];
    mainProgram = "faidx";
  };
}
