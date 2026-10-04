{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  gitMinimal,
  hatchling,
  setuptools-scm,

  doCheck ? false, # `gitMinimal` for tests depends on Rust, which depends on LLVM, which depends on `hatch-vcs`. So, disable tests by default to easily break the cycle.
}:

buildPythonPackage (finalAttrs: {
  pname = "hatch-vcs";
  version = "0.5.0";
  pyproject = true;

  src = fetchPypi {
    pname = "hatch_vcs";
    inherit (finalAttrs) version;
    hash = "sha256-A5X6EmlANAIVCQw0Siv04qd7y+faqxb0Gze5jJWAn/k=";
  };

  build-system = [ hatchling ];

  dependencies = [
    hatchling
    setuptools-scm
  ];

  inherit doCheck;

  nativeCheckInputs = [
    gitMinimal
    pytestCheckHook
  ];

  disabledTests = [
    # reacts to our setup-hook pretending a version
    "test_custom_tag_pattern_get_version"
  ];

  pythonImportsCheck = [ "hatch_vcs" ];

  passthru.tests.withChecks = finalAttrs.finalPackage.overrideAttrs { doInstallCheck = true; };

  meta = {
    changelog = "https://github.com/ofek/hatch-vcs/releases/tag/v${finalAttrs.version}";
    description = "Plugin for Hatch that uses your preferred version control system (like Git) to determine project versions";
    homepage = "https://github.com/ofek/hatch-vcs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
