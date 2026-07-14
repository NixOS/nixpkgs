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
  version = "1.0.4";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "Djelibeybi";
    repo = "aiolifx-themes";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FTQu8dvm3myRsMC2SKlvIk0MkRIuDPVv5Zxnw5IrPv4=";
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
