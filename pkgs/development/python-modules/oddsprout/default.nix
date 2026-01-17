{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  dahlia,
  ixia,
}:

buildPythonPackage (finalAttrs: {
  pname = "oddsprout";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "oddsprout";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RfAU3/Je3aC8JjQ51DqRCSAIfW2tQmQPP6G0/bfa1ZE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    dahlia
    ixia
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oddsprout" ];

  meta = {
    changelog = "https://github.com/trag1c/oddsprout/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Generate random JSON with no schemas involved";
    license = lib.licenses.mit;
    homepage = "https://trag1c.github.io/oddsprout";
    maintainers = with lib.maintainers; [
      itepastra
      sigmanificient
    ];
    mainProgram = "oddsprout";
  };
})
