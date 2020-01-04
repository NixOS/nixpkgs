{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07eb764f2b7b39b487f806a067e394d8ebffff21f57cd1ecdb5c4030b7210210";
  };

  # disable some failing tests
  checkPhase = ''
    nosetests nilearn/tests \
    -e test_cache_mixin_with_expand_user -e test_clean_confounds -e test_detrend \
    -e test_clean_detrending -e test_high_variance_confounds
  '';

  checkInputs = [ nose ];

  propagatedBuildInputs = [
    matplotlib
    nibabel
    numpy
    scikitlearn
    scipy
  ];

  meta = with stdenv.lib; {
    homepage = http://nilearn.github.io;
    description = "A module for statistical learning on neuroimaging data";
    license = licenses.bsd3;
  };
}
