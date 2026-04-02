{
  lib,
  aiolifx,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiolifx-themes";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y92ze+zrkz+fxQNFFSR5V9sPJMN0/dfIRwT6UhXo0+U=";
  };

  build-system = [ poetry-core ];

  dependencies = [ aiolifx ];

  nativeCheckInputs = [
    async-timeout
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "aiolifx_themes" ];

  meta = {
    description = "Color themes for LIFX lights running on aiolifx";
    homepage = "https://github.com/Djelibeybi/aiolifx-themes";
    changelog = "https://github.com/Djelibeybi/aiolifx-themes/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lukegb ];
  };
})
