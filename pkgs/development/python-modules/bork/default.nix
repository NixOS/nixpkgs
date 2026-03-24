{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  pytestCheckHook,

  setuptools,
  build,
  coloredlogs,
  homf,
  packaging,
  pip,
  pydantic,
  urllib3,
  writableTmpDirAsHomeHook,
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
    homf
    packaging
    pip
    pydantic
    urllib3
  ];

  pythonImportsCheck = [
    "bork"
    "bork.api"
    "bork.cli"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestMarks = [ "network" ];

  disabledTests = [
    # tries to call python -m bork
    "test_repo"
    # Attempt to install packages via pip
    "test_builder_cwd"
    "test_builder_order"
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
