{
  fetchFromGitHub,
  setuptools-scm,
  bioutils,
  buildPythonPackage,
  setuptools,
  cython,
  pysam,
  tqdm,
  requests,
  coloredlogs,
  six,
  typing-extensions,
  yoyo-migrations,
  pytestCheckHook,
  pytest-cov-stub,
  vcrpy,
  htslib,
  lib,
  ...
}:
buildPythonPackage (finalAttrs: {
  pname = "biocommons.seqrepo";
  version = "0.6.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "biocommons";
    repo = finalAttrs.pname;
    tag = finalAttrs.version;
    hash = "sha256-JQHKBojoXbVl74JP6xfe7p/CDhf1KzWo066R7Hy6K6Q=";
  };

  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  dependencies = [
    bioutils
    pysam
    tqdm
    requests
    coloredlogs
    six
    typing-extensions
    yoyo-migrations
  ];

  nativeBuildInputs = [
    htslib
  ];

  pythonCheckImports = [ "biocommons.seqrepo" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    vcrpy
  ];

  meta = {
    changelog = "https://github.com/biocommons/biocommons.seqrepo/releases/tag/${finalAttrs.src.tag}";
    description = "SeqRepo is a Python package for storing and reading a local collection of biological sequences.";
    homepage = "https://biocommons.org/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
