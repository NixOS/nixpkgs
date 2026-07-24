{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  cloudpickle,
  datasets,
  litellm,
  mcp,
  mlflow,
  tqdm,
  wandb,
}:

buildPythonPackage (finalAttrs: {
  pname = "gepa";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "gepa-ai";
    repo = "gepa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cmQQWTYNccHdbf+j+0fu1oJOLCL0z3YeBHke1tDjTps=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml --replace-fail 'version="0.1.0"' 'version="${finalAttrs.version}"'
  '';

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pytestCheckHook
    cloudpickle
    datasets
    litellm
    mcp
    mlflow
    tqdm
    wandb
  ];

  disabledTests = [
    # Tests require network access
    "test_e2e_resume_run"
    "test_aime_prompt_optimize"
    "test_callbacks_during_optimization"
    "test_multiple_callbacks_all_receive_events"
    "test_partial_callback_implementation"
    "test_aime_prompt_optimize_with_cache"
    "test_pareto_frontier_type_with_cache[objective]"
    "test_pareto_frontier_type_with_cache[hybrid]"
    "test_pareto_frontier_type_with_cache[instance]"
    "test_pareto_frontier_type[objective]"
    "test_pareto_frontier_type[hybrid]"
    "test_pareto_frontier_type[instance]"
  ];

  meta = {
    description = "Framework for optimizing any system with textual parameters against any evaluation metric";
    homepage = "https://gepa-ai.github.io/gepa/";
    changelog = "https://github.com/gepa-ai/gepa/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tim-tx ];
  };
})
