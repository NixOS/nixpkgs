{
  lib,
  buildPythonPackage,
  curl-cffi,
  fetchFromGitHub,
  hatchling,
  httpx,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "pywaze";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "pywaze";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ciSbI/giSqfdCbLaaRhFi3iNy3jbxhzOSpxXZmcPLjY=";
  };

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  build-system = [ hatchling ];

  dependencies = [
    curl-cffi
    httpx
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "pywaze" ];

  meta = {
    description = "Module for calculating WAZE routes and travel times";
    homepage = "https://github.com/eifinger/pywaze";
    changelog = "https://github.com/eifinger/pywaze/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
