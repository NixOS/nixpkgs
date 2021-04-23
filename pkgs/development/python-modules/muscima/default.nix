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
}:

buildPythonPackage rec {
  pname = "muscima";
#   version = "0.10.0";
  version = "unstable-2021-04-23";

  src = fetchgit {
    url = "https://github.com/hajicj/muscima.git";
    rev = "f6f3d014761442af52a108bb873786a41d6de4b3";
    sha256 = "08ibjcq3czphknzy4dn5b8rr6qhijcklyg0k5hkh5m5vhb68ff97";
  };
#   src = fetchPypi {
#     inherit pname version;
#     sha256 = "0w3bqbnllzjf9wxwvj46mvrgpb98x12zvdjdcalcziwm4pwrb2c4";
#   };

  propagatedBuildInputs = [
    lxml
    numpy
    scikitimage
    scikitlearn
    matplotlib
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
    description = "Tools for working with the MUSCIMA++ dataset of handwritten music notation";
    homepage = "https://github.com/hajicj/muscima";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
