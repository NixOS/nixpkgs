{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  hatchling,
  hatch-vcs,
  six,
  pyudev,
  pygobject3,
}:

buildPythonPackage rec {
  pname = "rtslib-fb";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "rtslib-fb";
    tag = "v${version}";
    hash = "sha256-lBYckQlnvIQ6lSENctYsMhzULi1MJAVUyF06Ul56LzA=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    six
    pyudev
    pygobject3
  ];

  meta = {
    description = "Python object API for managing the Linux LIO kernel target";
    mainProgram = "targetctl";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    changelog = "https://github.com/open-iscsi/rtslib-fb/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
  };
}
