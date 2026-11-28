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
  ipython,
}:
buildPythonPackage (finalAttrs: {
  pname = "biocommons.seqrepo";
  version = "0.6.11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biocommons";
    repo = "biocommons.seqrepo";
    tag = finalAttrs.version;
    hash = "sha256-JQHKBojoXbVl74JP6xfe7p/CDhf1KzWo066R7Hy6K6Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"setuptools ~= 69.0"' '"setuptools >= 69.0"' \
      --replace-fail '"setuptools_scm[toml] ~= 8.0"' '"setuptools_scm[toml]"'
  '';

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
    ipython
  ];

  pythonRelaxDeps = [
    "ipython"
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
    description = "Python package for storing and reading a local collection of biological sequences";
    homepage = "https://biocommons.org/en/latest/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rub-br ];
  };
})
