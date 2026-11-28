{
  lib,
  buildPythonPackage,
  fetchPypi,

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

buildPythonPackage (finalAttrs: {
  pname = "panphon";
  version = "0.22.2";
  pyproject = true;

  src = fetchPypi {
    pname = "panphon";
    inherit (finalAttrs) version;
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

  # Tests are not included in the PyPI distribution and the git repo does not have tagged releases
  doCheck = false;

  pythonImportsCheck = [
    "panphon"
    "panphon.segment"
    "panphon.distance"
  ];

  meta = {
    description = "Tools for using the International Phonetic Alphabet with phonological features";
    homepage = "https://github.com/dmort27/panphon";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vizid ];
  };
})
