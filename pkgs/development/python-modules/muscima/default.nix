{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, matplotlib
, numpy
, pytestCheckHook
, scikit-image
, scikit-learn
}:

let
  rev = "9a016380625927f385e699664026c90356557850";
in
buildPythonPackage {
  pname = "muscima";
  version = "unstable-2023-04-26";

  src = fetchFromGitHub {
    owner = "hajicj";
    repo = "muscima";
    inherit rev;
    hash = "sha256-0mRLJATn+6dYswgDg2zs7RHKSvY4+gNt4SBHeF0G3Xg=";
  };

  format = "setuptools";

  propagatedBuildInputs = [
    lxml
    numpy
    scikit-image
    scikit-learn
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # They hard-code the path to the dataset and expect you to edit the test to update it to your value
    "test/test_dataset.py"
  ];

  meta = with lib; {
    description = "Tools for working with the MUSCIMA++ dataset of handwritten music notation";
    homepage = "https://github.com/hajicj/muscima";
    changelog = "https://github.com/hajicj/muscima/blob/${rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
