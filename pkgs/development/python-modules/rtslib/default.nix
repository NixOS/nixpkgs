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
  version = "2.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "${pname}-fb";
    tag = "v${version}";
    hash = "sha256-lBYckQlnvIQ6lSENctYsMhzULi1MJAVUyF06Ul56LzA=";
  };

  propagatedBuildInputs = [
    six
    pyudev
    pygobject3
  ];

  meta = with lib; {
    description = "Python object API for managing the Linux LIO kernel target";
    mainProgram = "targetctl";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    license = licenses.asl20;
    platforms = platforms.linux;
  };
}
