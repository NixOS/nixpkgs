{ lib
, buildPythonPackage
, fetchPypi
, nose
, numpy
, setuptools-scm
, six
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pyfaidx";
  version = "0.6.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e6O9yx30unSfdmWzTmoFKqToQkBqDflebfRxfMEj85I=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    six
  ];

  checkInputs = [
    nose
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # PyPI releases don't ship all the needed files for the tests
    "test_index_zero_length"
    "test_fetch_zero_length"
    "test_read_back_index"
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
