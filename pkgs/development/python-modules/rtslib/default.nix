{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  six,
  pyudev,
  pygobject3,
}:

buildPythonPackage rec {
  pname = "rtslib";
  version = "2.1.76";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    rev = "refs/tags/v${version}";
    hash = "sha256-z9fpSVyv96ZoJaP0ch2A3bX/o/K23ooEpxa/OAhY6Z4=";
  };

  propagatedBuildInputs = [
    six
    pyudev
    pygobject3
  ];

  meta = with lib; {
    description = "A Python object API for managing the Linux LIO kernel target";
    mainProgram = "targetctl";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
