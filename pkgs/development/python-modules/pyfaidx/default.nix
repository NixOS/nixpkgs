{ lib
, buildPythonPackage
, fetchPypi
, importlib-metadata
, nose
, numpy
, setuptools
, setuptools-scm
, six
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.8.1.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bwSCNSYZ8sxWADyiIyG9sNB2S2VnlbweQGKx+psIaGs=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    importlib-metadata
    six
  ];

  nativeCheckInputs = [
    glibcLocales
    nose
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # FileNotFoundError: [Errno 2] No such file or directory: 'data/genes.fasta.gz'
    "tests/test_Fasta_bgzip.py"
  ];

  pythonImportsCheck = [
    "pyfaidx"
  ];

  meta = with lib; {
    homepage = "https://github.com/mdshw5/pyfaidx";
    description = "Python classes for indexing, retrieval, and in-place modification of FASTA files using a samtools compatible index";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jbedo ];
  };
}
