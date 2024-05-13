{
  lib,
  buildPythonPackage,
  fetchPypi,
  glibcLocales,
  importlib-metadata,
  numpy,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.8.1.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bwSCNSYZ8sxWADyiIyG9sNB2S2VnlbweQGKx+psIaGs=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ importlib-metadata ];

  nativeCheckInputs = [
    glibcLocales
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # FileNotFoundError: [Errno 2] No such file or directory: 'data/genes.fasta.gz'
    "tests/test_Fasta_bgzip.py"
  ];

  pythonImportsCheck = [ "pyfaidx" ];

  meta = with lib; {
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    homepage = "https://github.com/mdshw5/pyfaidx";
    changelog = "https://github.com/mdshw5/pyfaidx/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jbedo ];
    mainProgram = "faidx";
  };
}
