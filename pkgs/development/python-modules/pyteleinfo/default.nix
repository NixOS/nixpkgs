{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pydantic-settings,
  pyserial,
  pyserial-asyncio-fast,
  pyhamcrest,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyteleinfo";
  version = "0.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "esciara";
    repo = "pyteleinfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-uNkCunWlFoGmg80t69z2PXyPL1pGDsezTc8heec97VI=";
  };

  build-system = [ hatchling ];

  pythonRelaxDeps = [ "pydantic-settings" ];

  dependencies = [
    pydantic-settings
    pyserial
    pyserial-asyncio-fast
  ];

  nativeCheckInputs = [
    pyhamcrest
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "teleinfo" ];

  meta = {
    description = "Python library for decoding and encoding ENEDIS teleinfo frames";
    homepage = "https://github.com/esciara/pyteleinfo";
    changelog = "https://github.com/esciara/pyteleinfo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
