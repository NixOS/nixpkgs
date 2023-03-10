{ lib
, absl-py
, buildPythonPackage
, dm-tree
, docutils
, etils
, fetchFromGitHub
, numpy
, pythonOlder
, tabulate
, tensorflow
, tensorflow-datasets
, wrapt
}:

buildPythonPackage rec {
  pname = "dm-sonnet";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "sonnet";
    rev = "v${version}";
    hash = "sha256-YSMeH5ZTfP1OdLBepsxXAVczBG/ghSjCWjoz/I+TFl8=";
  };

  propagatedBuildInputs = [
    dm-tree
    etils
    numpy
    tabulate
    wrapt
  ] ++ etils.optional-dependencies.epath;

  passthru.optional-dependencies = {
    tensorflow = [
      tensorflow
    ];
  };

  nativeCheckInputs = [
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
