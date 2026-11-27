{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  modbus-connection,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "e3dc-ess-modbus";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AlCalzone";
    repo = "e3dc-ess-modbus";
    tag = finalAttrs.version;
    hash = "sha256-xlU7+XMnVQnulVUST3ZaZX/nCjGXMouv1DKVpZVYXgc=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [ modbus-connection ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "e3dc_ess_modbus" ];

  meta = {
    description = "Read and control E3/DC home power stations over Modbus TCP";
    homepage = "https://github.com/AlCalzone/e3dc-ess-modbus";
    changelog = "https://github.com/AlCalzone/e3dc-ess-modbus/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
