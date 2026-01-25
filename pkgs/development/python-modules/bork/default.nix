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
  packaging,
  pip,
  toml,
  urllib3,
}:

buildPythonPackage rec {
  pname = "bork";
  version = "10.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = "bork";
    tag = "v${version}";
    hash = "sha256-/euPRR6TRCAAl42CHePfUr+9Kh271iLjTayUR1S/FBg=";
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
  ++ lib.optionals (pythonOlder "3.11") [ toml ];

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
