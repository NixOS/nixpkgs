{ lib, buildPythonPackage, fetchPypi, pytestCheckHook, matplotlib
, nibabel, numpy, pandas, scikitlearn, scipy, joblib, requests }:

buildPythonPackage rec {
  pname = "nilearn";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1rhpy6na7hkhc211ri14zghvmb2fxkh995wi09pkc68klf1dzjg7";
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
