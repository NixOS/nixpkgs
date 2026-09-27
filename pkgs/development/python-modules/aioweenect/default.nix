{
  lib,
  aiohttp,
  aresponses,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioweenect";
  version = "1.1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eifinger";
    repo = "aioweenect";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YaIOCBBfL2lC6EPwBShVbPXiVlic7zK6pNOWjBJ/Y7I=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "--asyncio-mode=auto" ""
  '';

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "aioweenect" ];

  meta = {
    description = "Library for the weenect API";
    homepage = "https://github.com/eifinger/aioweenect";
    changelog = "https://github.com/eifinger/aioweenect/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
