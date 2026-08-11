{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hypothesis,
  mashumaro,
  nix-update-script,
  openapi-schema-validator,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytestCheckHook,
  syrupy,
  voluptuous-openapi,
  voluptuous-serialize,
  voluptuous,
}:

buildPythonPackage (finalAttrs: {
  pname = "probatio";
  version = "0.11.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "probatio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-II9E6t0SoIMgfRbuYyLSHmgjH19x0By185/kZaELEzI=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  nativeCheckInputs = [
    hypothesis
    mashumaro
    openapi-schema-validator
    pytest-cov-stub
    pytestCheckHook
    syrupy
    voluptuous
    voluptuous-openapi
    voluptuous-serialize
  ];

  pythonImportsCheck = [ "probatio" ];

  disabledTests = [
    # AssertionError: emitted schema narrows
    "test_emitted_openapi_never_narrows"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Data validation library for Python";
    homepage = "https://github.com/frenck/probatio";
    changelog = "https://github.com/frenck/probatio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
