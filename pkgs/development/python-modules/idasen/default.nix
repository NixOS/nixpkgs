{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  bleak,
  pyyaml,
  voluptuous,
  pytestCheckHook,
  pytest-asyncio,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "idasen";
  version = "0.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "idasen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ejKfXAVvHyWIkg06XqC2pKJjpPuOgHEciPzBb/TGiSU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bleak
    pyyaml
    voluptuous
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [ "idasen" ];

  meta = {
    description = "Python API and CLI for the ikea IDÅSEN desk";
    mainProgram = "idasen";
    homepage = "https://github.com/newAM/idasen";
    changelog = "https://github.com/newAM/idasen/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ newam ];
  };
})
