{
  lib,
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiothreads";
  version = "1.1.4";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mosquito";
    repo = "aiothreads";
    tag = finalAttrs.version;
    hash = "sha256-5s1CGoq7z78Fq9YPiTI+XcPKqsE/lBcv8XL+xhv00KY=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiothreads" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module to bridge async and thread";
    homepage = "https://github.com/mosquito/aiothreads";
    changelog = "https://github.com/mosquito/aiothreads/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
