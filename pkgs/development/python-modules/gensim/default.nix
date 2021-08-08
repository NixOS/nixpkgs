{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, scipy
, smart-open
, scikit-learn, testfixtures, unittest2
, isPy3k
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "4.0.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a9c9fed52e2901ad04f9caf73a5dd782e5ce8054f71b346d72f04ddff1b7b432";
  };

  propagatedBuildInputs = [ smart-open numpy six scipy ];

  checkInputs = [ scikit-learn testfixtures unittest2 ];

  # Two tests fail.
  #
  # ERROR: testAddMorphemesToEmbeddings (gensim.test.test_varembed_wrapper.TestVarembed)
  # ImportError: Could not import morfessor.
  # This package is not in nix
  #
  # ERROR: testWmdistance (gensim.test.test_fasttext_wrapper.TestFastText)
  # ImportError: Please install pyemd Python package to compute WMD.
  # This package is not in nix
  doCheck = false;

  meta = {
    description = "Topic-modelling library";
    homepage = "https://radimrehurek.com/gensim/";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jyp ];
  };
}
