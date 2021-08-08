{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, matplotlib
, nibabel, numpy, pandas, scikit-learn, scipy, joblib, requests }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2d3dc81005f829f3a183efa6c90d698ea6818c06264d2e3f03e805c4340febb";
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
