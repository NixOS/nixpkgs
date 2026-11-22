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
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "newAM";
    repo = "idasen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-COxI97ndHbAiIjRs78jyIN4la8n52wi1AyeXMVQXhA4=";
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
