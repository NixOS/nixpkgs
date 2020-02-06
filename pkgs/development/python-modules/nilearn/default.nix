{ stdenv, buildPythonPackage, fetchPypi, pytest
, nibabel, numpy, pandas, scikitlearn, scipy, matplotlib, joblib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07eb764f2b7b39b487f806a067e394d8ebffff21f57cd1ecdb5c4030b7210210";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "required_packages.append('sklearn')" ""
  '';
  # https://github.com/nilearn/nilearn/issues/2288

  # disable some failing tests
  checkPhase = ''
    pytest nilearn/tests -k 'not test_cache_mixin_with_expand_user'  # accesses ~/
  '';

  checkInputs = [ pytest ];

  propagatedBuildInputs = [
    joblib
    matplotlib
    nibabel
    numpy
    pandas
    scikitlearn
    scipy
  ];

  meta = with stdenv.lib; {
    homepage = http://nilearn.github.io;
    description = "A module for statistical learning on neuroimaging data";
    license = licenses.bsd3;
  };
}
