{
  lib,
  stdenv,
  buildPythonPackage,
  git,
  gnupg,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "git-revise";
  version = "0.7.0-unstable-2025-01-28";
  format = "setuptools";

  # Missing tests on PyPI
  src = fetchFromGitHub {
    owner = "mystor";
    repo = "git-revise";
    rev = "189c9fe150e5587def75c51709246c47c93e3b4d";
    hash = "sha256-bqhRV0WtWRUKkBG2tEvctxdoYRkcrpL4JZSHYzox8so=";
  };

  nativeCheckInputs = [
    git
    pytestCheckHook
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    gnupg
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # `gpg: agent_genkey failed: No agent running`
    "test_gpgsign"
  ];

  meta = {
    description = "Efficiently update, split, and rearrange git commits";
    homepage = "https://github.com/mystor/git-revise";
    changelog = "https://github.com/mystor/git-revise/blob/${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "git-revise";
    maintainers = with lib.maintainers; [ _9999years ];
  };
}
