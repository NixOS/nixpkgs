{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,

  setuptools,
  build,
  coloredlogs,
  importlib-metadata,
  packaging,
  pip,
  toml,
  urllib3,
}:

buildPythonPackage rec {
  pname = "bork";
  version = "9.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

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
  ]
  ++ lib.optionals (pythonOlder "3.11") [ toml ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

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

  meta = with lib; {
    description = "Python build and release management tool";
    mainProgram = "bork";
    homepage = "https://github.com/duckinator/bork";
    license = licenses.mit;
    maintainers = with maintainers; [ nicoo ];
  };
}
