{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, matplotlib
, nibabel, numpy, pandas, scikitlearn, scipy, joblib, requests }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8b1409a5e1f0f6d1a1f02555c2f11115a2364f45f1e57bcb5fb3c9ea11f346fa";
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
    scikitlearn
    scipy
  ];

  meta = with lib; {
    homepage = "https://nilearn.github.io";
    description = "A module for statistical learning on neuroimaging data";
    license = licenses.bsd3;
  };
}
