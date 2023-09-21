{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, matplotlib
, midiutil
, numpy
, pytestCheckHook
, scikit-image
, scikit-learn
}:
let
  rev = "8d0ce91d831b0592c111ddb38fc9aa8eba130ed2";
in
buildPythonPackage {
  pname = "mung";
  version = "unstable-2022-07-10";

  src = fetchFromGitHub {
    owner = "OMR-Research";
    repo = "mung";
    inherit rev;
    hash = "sha256-QzCkB9Wj4dTPuMCMweFw6IsSwBBzV0Nfx7+VX7Plnio=";
  };

  format = "setuptools";

  propagatedBuildInputs = [
    lxml
    numpy
    scikit-image
    scikit-learn
    matplotlib
    midiutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Music Notation Graph: a data model for optical music recognition";
    homepage = "https://github.com/OMR-Research/mung";
    changelog = "https://github.com/OMR-Research/mung/blob/${rev}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
