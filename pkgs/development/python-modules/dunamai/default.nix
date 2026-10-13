{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  packaging,

  # tests
  addBinToPathHook,
  gitMinimal,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "dunamai";
  version = "1.25.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mtkennerly";
    repo = "dunamai";
    tag = "v${version}";
    hash = "sha256-kPOEhJwsSzGea7fS5y5tbAvzZZ+OxIyjpYpS6i++rHE=";
  };

  build-system = [ poetry-core ];

  dependencies = [ packaging ];

  preCheck = ''
    git config --global user.email "nobody@example.com"
    git config --global user.name "Nobody"
  '';

  nativeCheckInputs = [
    addBinToPathHook
    gitMinimal
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # clones from github.com
    "test__version__from_git__shallow"
  ]
  # If Git has been compiled with breaking changes enabled, disable tests that
  # are known to be broken in that environment while we wait for upstream
  # fixes.
  #
  # https://github.com/mtkennerly/dunamai/issues/117
  # https://github.com/NixOS/nixpkgs/issues/571330
  ++ lib.optionals (builtins.elem "WITH_BREAKING_CHANGES=YesPlease" gitMinimal.makeFlags) [
    "test__version__from_git__with_lightweight_tag"
    "test__version__from_git__with_mixed_tags"
    "test__version__from_git__with_nonchronological_commits"
    "test__version__from_git__gitflow"
    "test__version__from_git__exclude_decoration"
    "test__version__from_git__broken_ref"
  ];

  pythonImportsCheck = [ "dunamai" ];

  meta = {
    description = "Dynamic version generation";
    mainProgram = "dunamai";
    homepage = "https://github.com/mtkennerly/dunamai";
    changelog = "https://github.com/mtkennerly/dunamai/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jmgilman ];
  };
}
