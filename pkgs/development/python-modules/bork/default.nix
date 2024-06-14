{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  build,
  coloredlogs,
  packaging,
  pip,
  readme-renderer,
  toml,
  twine,
}:

buildPythonPackage rec {
  pname = "bork";
  version = "8.0.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "duckinator";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BDwVhKmZ/F8CvpT6dEI5moQZx8wHy1TwdOl889XogEo=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "packaging"
    "readme-renderer"
    "twine"
    "wheel"
  ];

  dependencies = [
    build
    coloredlogs
    packaging
    pip
    readme-renderer
    twine
  ] ++ lib.optionals (pythonOlder "3.11") [ toml ];

  pythonImportsCheck = [
    "bork"
    "bork.api"
    "bork.cli"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "-m 'not network'" ];

  disabledTests = [
    # tries to call python -m bork
    "test_repo"
  ];

  meta = with lib; {
    description = "Python build and release management tool";
    mainProgram = "bork";
    homepage = "https://github.com/duckinator/bork";
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.all;
  };
}
