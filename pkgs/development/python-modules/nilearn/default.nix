{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, matplotlib
, nibabel, numpy, pandas, scikit-learn, scipy, joblib, requests }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-+cjjCt71FImRCux3JLVpneF4Qn065jhz2tmyPdMh/nY=";
  };

  checkInputs = [ pytestCheckHook ];
  disabledTests = [ "test_clean_confounds" ];  # https://github.com/nilearn/nilearn/issues/2608
  # do subset of tests which don't fetch resources
  pytestFlagsArray = [ "nilearn/connectome/tests" ];

  propagatedBuildInputs = [
    joblib
    matplotlib
    nibabel
    numpy
    pandas
    requests
    scikit-learn
    scipy
  ];

  meta = with lib; {
    homepage = "https://nilearn.github.io";
    description = "A module for statistical learning on neuroimaging data";
    license = licenses.bsd3;
  };
}
