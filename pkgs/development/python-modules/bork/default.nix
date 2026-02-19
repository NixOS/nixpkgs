{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pytestCheckHook,

  setuptools,
  build,
  coloredlogs,
  packaging,
  pip,
  urllib3,
}:

buildPythonPackage rec {
  pname = "bork";
  version = "9.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = "bork";
    tag = "v${version}";
    hash = "sha256-YqvtOwd00TXD4I3fIQolvjHnjREvQgbdrEO9Z96v1Kk=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "build"
    "packaging"
    "urllib3"
  ];

  dependencies = [
    build
    coloredlogs
    packaging
    pip
    urllib3
  ];

  pythonImportsCheck = [
    "bork"
    "bork.api"
    "bork.cli"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestMarks = [ "network" ];

  disabledTests = [
    # tries to call python -m bork
    "test_repo"
  ];

  passthru.tests = callPackage ./tests.nix { };

  meta = {
    description = "Python build and release management tool";
    mainProgram = "bork";
    homepage = "https://github.com/duckinator/bork";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nicoo ];
  };
}
