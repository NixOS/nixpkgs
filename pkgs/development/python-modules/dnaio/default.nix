{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,
  setuptools-scm,
  cython,

  # deps
  xopen,

  # tests
  pytestCheckHook,

  # update
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "dnaio";
  version = "1.2.4";
  pyproject = true;
  build-system = [
    setuptools
    setuptools-scm
    cython
  ];

  src = fetchFromGitHub {
    owner = "marcelm";
    repo = "dnaio";
    tag = "v${version}";
    hash = "sha256-YNf4/hvwSkKqQA12+em62DyaUNK7ftOOIlOKwmCwRpU=";
  };

  dependencies = [ xopen ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [ ];

  pythonImportsCheck = [ "dnaio" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Read and write FASTA and FASTQ files efficiently";
    longDescription = ''
      Python 3 library for very efficient parsing and writing of FASTQ, FASTA
      and parsing uBAM files. This allows reading ONT files from the dorado
      basecaller directly
    '';
    homepage = "https://dnaio.readthedocs.io";
    downloadPage = "https://github.com/marcelm/dnaio/tags";
    changelog = "https://github.com/marcelm/dnaio/blob/main/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.kupac ];
  };
}
