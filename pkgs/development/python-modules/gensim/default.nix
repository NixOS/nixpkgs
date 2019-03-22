{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, scipy
, smart_open
, scikitlearn, testfixtures, unittest2
}:

buildPythonPackage rec {
  pname = "gensim";
  version = "3.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ed845ac585f724ae1f40fdb517ed8ade822531f9bbcd1be4a599c2e86aff48a8";
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
