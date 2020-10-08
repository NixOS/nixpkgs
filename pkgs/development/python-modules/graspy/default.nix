{ lib
, buildPythonPackage
, isPy27
, fetchFromGitHub
, pytestCheckHook
, pytestcov
, hyppo
, matplotlib
, networkx
, numpy
, scikitlearn
, scipy
, seaborn
}:

buildPythonPackage rec {
  pname = "graspy";
  version = "0.3";

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "neurodata";
    repo = pname;
    rev = "v${version}";
    sha256 = "0lab76qiryxvwl6zrcikhnxil1xywl0wkkm2vzi4v9mdzpa7w29r";
  };

  propagatedBuildInputs = [
    hyppo
    matplotlib
    networkx
    numpy
    scikitlearn
    scipy
    seaborn
  ];

  checkInputs = [ pytestCheckHook pytestcov ];
  pytestFlagsArray = [ "tests" "--ignore=docs" ];
  disabledTests = [ "gridplot_outputs" ];

  meta = with lib; {
    homepage = "https://graspy.neurodata.io";
    description = "A package for graph statistical algorithms";
    license = licenses.asl20;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
