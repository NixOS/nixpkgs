{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, matplotlib
, nibabel, numpy, pandas, scikit-learn, scipy, joblib, requests }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0489940855130f35bbc4cac0750479a6f82025215ea7b1d778faca064219298";
  };

  checkInputs = [ pytestCheckHook ];
  disabledTests = [ "test_clean_confounds" ];  # https://github.com/nilearn/nilearn/issues/2608

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
