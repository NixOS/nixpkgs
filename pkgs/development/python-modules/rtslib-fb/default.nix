{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # build-system
  hatchling,
  hatch-vcs,

  # dependencies
  pyudev,
}:

buildPythonPackage rec {
  pname = "rtslib-fb";
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "open-iscsi";
    repo = "rtslib-fb";
    tag = "v${version}";
    hash = "sha256-UGRQMdOkyPZWjXoJUsXuWqstb473KR+Sf9XHbjIdfJ8=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    pyudev
  ];

  # No tests
  doCheck = false;

  meta = {
    description = "Python object API for managing the Linux LIO kernel target";
    homepage = "https://github.com/open-iscsi/rtslib-fb";
    changelog = "https://github.com/open-iscsi/rtslib-fb/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.linux;
    mainProgram = "targetctl";
  };
}
