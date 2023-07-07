{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.7.2.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-MPDSCp49UzU/sg62m34i5vAaU+1PIbPhfdQI8L5QUaA=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
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
