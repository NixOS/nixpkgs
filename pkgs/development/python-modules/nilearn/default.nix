{ stdenv, buildPythonPackage, fetchPypi, pytest, nose
, nibabel, numpy, pandas, scikitlearn, scipy, matplotlib, joblib }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.6.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfc6cfda59a6f4247189f8ccf92e364de450460a15c0ec21bdb857c420dd198c";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "required_packages.append('sklearn')" ""
  '';
  # https://github.com/nilearn/nilearn/issues/2288

  # disable some failing tests
  checkPhase = ''
    pytest nilearn/tests -k 'not test_cache_mixin_with_expand_user'  # accesses ~/
  '';

  checkInputs = [ pytest nose ];

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
    homepage = "http://nilearn.github.io";
    description = "A module for statistical learning on neuroimaging data";
    license = licenses.bsd3;
  };
}
