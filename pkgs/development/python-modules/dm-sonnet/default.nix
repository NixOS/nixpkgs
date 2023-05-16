{ lib
<<<<<<< HEAD
, buildPythonPackage
, click
=======
, absl-py
, buildPythonPackage
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dm-tree
, docutils
, etils
, fetchFromGitHub
<<<<<<< HEAD
, fetchpatch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  patches = [
    (fetchpatch {
      name = "replace-np-bool-with-np-bool_.patch";
      url = "https://github.com/deepmind/sonnet/commit/df5d099d4557a9a81a0eb969e5a81ed917bcd612.patch";
      hash = "sha256-s7abl83osD4wa0ZhqgDyjqQ3gagwGYCdQifwFqhNp34=";
    })
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    click
    docutils
    tensorflow
=======
    docutils
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
