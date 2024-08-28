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
  levenshtein,
}:

buildPythonPackage rec {
  pname = "panphon";
  version = "0.21.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Zgug40R1my1BPOoV9iOkbzouMKeQsc0YYFmBIoypDqk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    setuptools # need for pkg_resources
    unicodecsv
    pyyaml
    regex
    numpy
    editdistance
    munkres
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
