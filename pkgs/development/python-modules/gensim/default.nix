{ lib
, buildPythonPackage
, fetchPypi
, numpy
, six
, scipy
, smart_open
, scikitlearn
, testfixtures
, unittest2
}:

buildPythonPackage rec {
  pname = "gensim";
  name = "${pname}-${version}";
  version = "3.2.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "db00b68c6567ba0598d400b917c889e8801adf249170ce0a80ec38187d1b0797";
  };

  propagatedBuildInputs = [ smart_open numpy six scipy
                            # scikitlearn testfixtures unittest2 # for tests
                          ];
  doCheck = false;

  # Two tests fail.

  # ERROR: testAddMorphemesToEmbeddings (gensim.test.test_varembed_wrapper.TestVarembed)
  # ImportError: Could not import morfessor.
  # This package is not in nix

  # ERROR: testWmdistance (gensim.test.test_fasttext_wrapper.TestFastText)
  # ImportError: Please install pyemd Python package to compute WMD.
  # This package is not in nix

  meta = {
    description = "Topic-modelling library";
    homepage = https://radimrehurek.com/gensim/;
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ jyp ];
  };
}
