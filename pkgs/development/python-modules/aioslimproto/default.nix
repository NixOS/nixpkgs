{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pillow,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioslimproto";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aioslimproto";
    tag = finalAttrs.version;
    hash = "sha256-98GLhv60SaPQIi8OEWTVPz+3TT2rBRuXUKfF/8TG/nU=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pillow
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioslimproto" ];

  meta = {
    description = "Module to control Squeezebox players";
    homepage = "https://github.com/home-assistant-libs/aioslimproto";
    changelog = "https://github.com/home-assistant-libs/aioslimproto/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
