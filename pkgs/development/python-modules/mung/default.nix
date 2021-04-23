{ lib
, fetchgit
# , fetchPypi
, buildPythonPackage
, pytest
, lxml
, scikitimage
, scikitlearn
, matplotlib
, numpy
, midiutil
}:

buildPythonPackage rec {
  pname = "mung";
  version = "unstable-2021-04-23";

  src = fetchgit {
    url = "https://github.com/OMR-Research/mung.git";
    rev = "8fc816177e15889bd397eb20725441dbe21b8620";
    sha256 = "1sann02126aas61f67kn4038raaj9arwq302nmi6vihsawy40sm5";
  };
#   src = fetchPypi {
#     inherit pname version;
#     sha256 = "17mjkiizfz3441h3xksw4bdaxv9962qsbdqip3vw39jglm78cpv1";
#   };

  propagatedBuildInputs = [
    lxml
    numpy
    scikitimage
    scikitlearn
    matplotlib
    midiutil
  ];

  checkInputs = [
    pytest
  ];

  checkPhase = ''
    pytest test/
  '';

  # The scripts in there don't look like they were meant to be packaged
  removeBin = ''
    rm -r $out/bin
  '';
  postPhases = ["removeBin"];

  meta = with lib; {
    description = "Music Notation Graph: a data model for optical music recognition";
    homepage = "https://github.com/OMR-Research/mung";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
