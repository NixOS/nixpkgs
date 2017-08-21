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
  version = "2.1.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "1wn7bji9b80wn1yggmh7a0dlwzdjr6cp24x4p33j2rf29lxnm2kc";
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
    maintainers = with lib.maintainers; [ jpbernardy ];
  };
}
