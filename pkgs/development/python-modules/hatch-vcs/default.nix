{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  gitMinimal,
  hatchling,
  setuptools-scm,

  # Disable checks by default, as they require gitMinimal, which is built with
  # Rust, and rustc's build depends on this package, leading to infinite
  # recursion.
  doCheck ? false,

  # self-reference for tests, since finalAttrs.finalPackage exposes neither
  # `override` nor `overridePythonAttrs`.
  hatch-vcs,
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

  # In passthru.tests, build with the check phase enabled, since that'll be
  # outside the bootstrap dependency chain.
  passthru.tests.withChecks = hatch-vcs.override { doCheck = true; };

  meta = {
    changelog = "https://github.com/ofek/hatch-vcs/releases/tag/v${finalAttrs.version}";
    description = "Plugin for Hatch that uses your preferred version control system (like Git) to determine project versions";
    homepage = "https://github.com/ofek/hatch-vcs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
  };
})
