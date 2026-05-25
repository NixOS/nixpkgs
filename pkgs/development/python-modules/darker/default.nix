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

buildPythonPackage (finalAttrs: {
  pname = "darker";
  version = "2.1.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akaihola";
    repo = "darker";
    tag = "v${finalAttrs.version}";
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
    # Nix injects extra shell variables that cause the git-call assertion to fail
    "test_git_exists_in_revision_git_call"
    # argparse fails because it expects at least one PATH argument
    "test_main_stdin_filename"
  ];

  pythonImportsCheck = [ "darker" ];

  meta = {
    changelog = "https://github.com/akaihola/darker/releases/tag/v${finalAttrs.version}";
    description = "Apply Black formatting only in regions changed since last commit";
    homepage = "https://github.com/akaihola/darker";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philocalyst ];
    mainProgram = "darker";
  };
})
