{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, setuptools-scm
, six
, glibcLocales
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-OXdjK3/SkEn4sRA11+neoOLF2pwjX5grTD+uBv8foj8=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
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
