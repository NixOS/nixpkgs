{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, scipy
, smart_open
, scikitlearn, testfixtures, unittest2
, isPy3k
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "3.8.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0rjpmxcd4hphq41y7frg6by6gwjjmrdbnim8jvx951ps5gzyfpgc";
  };

  propagatedBuildInputs = [ smart_open numpy six scipy ];

  checkInputs = [ scikitlearn testfixtures unittest2 ];

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
    homepage = https://radimrehurek.com/gensim/;
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jyp ];
  };
}
