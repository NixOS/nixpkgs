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
  version = "0.8.0";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Hu1w9Or7S6nEz3AizXSJR7jr4PTIbLVvQvWHq38toCc=";
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
