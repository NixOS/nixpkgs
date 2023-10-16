{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, numpy
, pytestCheckHook
, scikit-image
}:
let
  version = "1.2";
in
buildPythonPackage {
  pname = "mung";
  inherit version;

  src = fetchFromGitHub {
    owner = "OMR-Research";
    repo = "mung";
    rev = "refs/tags/${version}";
    hash = "sha256-NSKaJkJRevTy5gh6/ik8Qe46bOPdznsmXPgh7Xz7vXQ=";
  };

  format = "setuptools";

  propagatedBuildInputs = [
    lxml
    numpy
    scikit-image
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Music Notation Graph: a data model for optical music recognition";
    homepage = "https://github.com/OMR-Research/mung";
    changelog = "https://github.com/OMR-Research/mung/blob/${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
