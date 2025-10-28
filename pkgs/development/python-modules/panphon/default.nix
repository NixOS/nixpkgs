{
  lib,
  buildPythonPackage,
  fetchPypi,

  unittestCheckHook,

  setuptools,

  unicodecsv,
  pyyaml,
  regex,
  numpy,
  editdistance,
  munkres,
  pandas,
  levenshtein,
}:

buildPythonPackage rec {
  pname = "panphon";
  version = "0.22.2";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OD1HfVh/66HKWoKHjiT+d8FkXW++ngHJ6X1JjYopujU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    unicodecsv
    pyyaml
    regex
    numpy
    editdistance
    munkres
    pandas
    levenshtein # need for align_wordlists.py script
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "test"
  ];

  pythonImportsCheck = [
    "panphon"
    "panphon.segment"
    "panphon.distance"
  ];

  meta = with lib; {
    description = "Tools for using the International Phonetic Alphabet with phonological features";
    homepage = "https://github.com/dmort27/panphon";
    license = licenses.mit;
    maintainers = with maintainers; [ vizid ];
  };
}
