{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  setuptools,
  black,
  darkgraylib,
  graylint,
  toml,
  typing-extensions,
  flynt,
  isort,
  pygments,
  pytestCheckHook,
  pytest-kwparametrize,
  pip-requirements-parser,
  regex,
  gitMinimal,
}:

buildPythonPackage rec {
  pname = "darker";
  version = "2.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "darker";
    rev = "refs/tags/v${version}";
    hash = "sha256-uh9PUuEO9XpDcbSwhCz6evAP6KUfgU2j3JH8aW8rHek=";
  };

  patches = [
    (fetchpatch2 {
      name = "darkgraylib-2.0.0-fix.patch";
      url = "https://github.com/akaihola/darker/commit/cc96c66cab8e7887f462d274784e1126feb02a99.patch?full_index=1";
      hash = "sha256-EIupMBohSPgFFQNyt7o0enOpyhkWHlXTEPpCvCyLOwA=";
    })
  ];

  pythonRelaxDeps = [
    "darkgraylib"
    "graylint"
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    black
    darkgraylib
    graylint
    toml
    typing-extensions
  ];

  optional-dependencies = {
    flynt = [ flynt ];
    isort = [ isort ];
    color = [ pygments ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-kwparametrize
    regex
    pip-requirements-parser
    flynt
    isort
    pygments
    gitMinimal
  ];

  disabledTests = [
    # Always fails because it doesn't account for nix-injected shell variables
    "test_git_exists_in_revision_git_call"
    # argparse.ArgumentError: the following arguments are required: PATH
    "test_main_stdin_filename"
  ];

  pythonImportsCheck = [ "darker" ];

  meta = {
    changelog = "https://github.com/akaihola/darker/releases/tag/v${version}";
    description = "Apply Black formatting only in regions changed since last commit";
    homepage = "https://github.com/akaihola/darker";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "darker";
  };
}
