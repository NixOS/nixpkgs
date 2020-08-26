{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, scikitlearn
, pyaml
, pytest
}:

buildPythonPackage rec {
  pname = "scikit-optimize";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "scikit-optimize";
    repo = "scikit-optimize";
    rev = "v${version}";
    sha256 = "1srbb20k8ddhpcfxwdflapfh6xfyrd3dnclcg3bsfq1byrcmv0d4";
  };

  propagatedBuildInputs = [
    numpy
    scipy
    scikitlearn
    pyaml
  ];

  checkInputs = [
    pytest
  ];

  # remove --ignore at next release > 0.6
  checkPhase = ''
    pytest skopt --ignore skopt/tests/test_searchcv.py
  '';

  meta = with lib; {
    description = "Sequential model-based optimization toolbox";
    homepage = "https://scikit-optimize.github.io/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
