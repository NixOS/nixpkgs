{
  lib,
  stdenv,
  buildPythonPackage,
  hatchling,
  git,
  openssh,
  gnupg,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "git-revise";
  version = "0.8.0";
  pyproject = true;

  # Missing tests on PyPI
  src = fetchFromGitHub {
    owner = "mystor";
    repo = "git-revise";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OdkhYEq30RtDOeCQWl/L9FMgCttznzihbYgT8B6KYuY=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    git
    openssh
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
    changelog = "https://github.com/mystor/git-revise/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    mainProgram = "git-revise";
    maintainers = with lib.maintainers; [ _9999years ];
  };
})
