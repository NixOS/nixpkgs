{ lib
, fetchFromGitHub
, buildPythonPackage
, numpy
, tabulate
, six
, dm-tree
, absl-py
, wrapt
, docutils
, tensorflow
, tensorflow-datasets }:

buildPythonPackage rec {
  pname = "dm-sonnet";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "sonnet";
    rev = "v${version}";
    sha256 = "sha256-YSMeH5ZTfP1OdLBepsxXAVczBG/ghSjCWjoz/I+TFl8=";
  };

  buildInputs = [
    absl-py
    dm-tree
    numpy
    six
    tabulate
    wrapt
  ];

  propagatedBuildInputs = [
    tabulate
    tensorflow
  ];

  checkInputs = [
    docutils
    tensorflow-datasets
  ];

  pythonImportsCheck = [
    "sonnet"
  ];

  meta = with lib; {
    description = "Library for building neural networks in TensorFlow";
    homepage = "https://github.com/deepmind/sonnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ onny ];
  };
}
