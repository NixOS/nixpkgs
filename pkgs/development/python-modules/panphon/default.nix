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
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gio52n1NZWeyCK+eJW/Fp827wjvwnMNDFAR4pKa8VcY=";
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
