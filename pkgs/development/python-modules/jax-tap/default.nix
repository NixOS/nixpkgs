{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  jax,

  # optional-dependencies
  pandas,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jax-tap";
  version = "0.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arcueil";
    repo = "jax-tap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xMBiEuACoPFSIlhR+/k4dBCGxqDqN7jkioSmsBlpWYk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    jax
  ];

  optional-dependencies = {
    pandas = [
      pandas
    ];
  };

  pythonImportsCheck = [ "jaxtap" ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
  ];

  disabledTests = [
    # 1-ULP float32 drift between tapped and untapped programs since jax 0.12.1 (XLA CPU codegen change)
    # AssertionError: ... not bitwise identical
    "test_ashell_cache_hit_new_context"
    "test_identity_bitwise"
    "test_jit_composition"
    "test_m0_bitwise_still_holds"
    "test_max_depth_0"
    "test_where_no_match"
    "test_where_outer_only"
  ];

  meta = {
    description = "Make print-debugging great again";
    homepage = "https://github.com/arcueil/jax-tap";
    changelog = "https://github.com/arcueil/jax-tap/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
