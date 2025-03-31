{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonOlder,
  dahlia,
  ixia,
}:

buildPythonPackage rec {
  pname = "oddsprout";
  version = "0.1.2";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "trag1c";
    repo = "oddsprout";
    tag = "v${version}";
    hash = "sha256-RfAU3/Je3aC8JjQ51DqRCSAIfW2tQmQPP6G0/bfa1ZE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    dahlia
    ixia
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "oddsprout" ];

  meta = with lib; {
    changelog = "https://github.com/trag1c/oddsprout/blob/${src.rev}/CHANGELOG.md";
    description = "Generate random JSON with no schemas involved";
    license = licenses.mit;
    homepage = "https://trag1c.github.io/oddsprout";
    maintainers = with maintainers; [
      itepastra
      sigmanificient
    ];
    mainProgram = "oddsprout";
  };
}
