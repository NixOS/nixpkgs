{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, matplotlib
, numpy
, pytestCheckHook
, scikitimage
, scikitlearn
}:

buildPythonPackage rec {
  pname = "muscima";
  version = "unstable-2021-04-23";

  src = fetchFromGitHub {
    owner = "hajicj";
    repo = "muscima";
    rev = "f6f3d014761442af52a108bb873786a41d6de4b3";
    sha256 = "08ibjcq3czphknzy4dn5b8rr6qhijcklyg0k5hkh5m5vhb68ff97";
  };

  propagatedBuildInputs = [
    lxml
    numpy
    scikitimage
    scikitlearn
    matplotlib
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Tools for working with the MUSCIMA++ dataset of handwritten music notation";
    homepage = "https://github.com/hajicj/muscima";
    license = licenses.mit;
    maintainers = with maintainers; [ piegames ];
  };
}
