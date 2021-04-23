{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, matplotlib
, midiutil
, numpy
, pytestCheckHook
, scikitimage
, scikitlearn
}:

buildPythonPackage rec {
  pname = "mung";
  version = "unstable-2021-04-23";

  src = fetchFromGitHub {
    owner = "OMR-Research";
    repo = "mung";
    rev = "8fc816177e15889bd397eb20725441dbe21b8620";
    sha256 = "1sann02126aas61f67kn4038raaj9arwq302nmi6vihsawy40sm5";
  };

  propagatedBuildInputs = [
    lxml
    numpy
    scikitimage
    scikitlearn
    matplotlib
    midiutil
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Music Notation Graph: a data model for optical music recognition";
    homepage = "https://github.com/OMR-Research/mung";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
