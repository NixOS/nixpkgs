{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.5.1";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "dca56e8a1f0fc6dcd1c997383187efc31788294ac6bcbbaebac2b9a962a44cbb";
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
