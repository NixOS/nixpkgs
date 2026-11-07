{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  pydantic,

  # tests
  openapi-spec-validator,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "openapi-pydantic";
  version = "0.6.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mike-oakley";
    repo = "openapi-pydantic";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8vjZ2Sy5LY3h5PacLyUIga/xorGM27WmWxAHI6i7wUs=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    pydantic
  ];

  pythonImportsCheck = [
    "openapi_pydantic"
  ];

  nativeCheckInputs = [
    openapi-spec-validator
    pytestCheckHook
  ];

  meta = {
    description = "Pydantic OpenAPI schema implementation";
    homepage = "https://github.com/mike-oakley/openapi-pydantic";
    changelog = "https://github.com/mike-oakley/openapi-pydantic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taha-yassine ];
  };
})
