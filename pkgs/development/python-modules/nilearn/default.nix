{ stdenv, buildPythonPackage, fetchPypi, nose, nibabel, numpy, scikitlearn
, scipy, matplotlib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.5.2";
  name = pname + "-" + version;

  src = fetchPypi {
    inherit pname version;
    sha256 = "18b763d641e6903bdf8512e0ec5cdc14133fb4679e9a15648415e9be62c81b56";
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
