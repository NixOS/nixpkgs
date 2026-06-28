{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "whichllm";
  version = "0.5.12";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Andyyyy64";
    repo = "whichllm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-B/pJyRMJBkxs9ANGVDN+ub8yKCOxtNQ+uHsy7i71BOE=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies =
    with python3Packages;
    [
      dbgpu
      httpx
      nvidia-ml-py
      psutil
      rich
      typer
    ]
    ++ dbgpu.optional-dependencies.fuzz;

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  disabledTests = [
    # require network access
    "test_plan_no_model_found_shows_error"
    "test_snippet_no_model_found"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  pythonImportsCheck = [ "whichllm" ];

  meta = {
    description = "Find the local LLM that actually runs and performs best on your hardware";
    homepage = "https://github.com/Andyyyy64/whichllm";
    changelog = "https://github.com/Andyyyy64/whichllm/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jaredmontoya ];
    mainProgram = "whichllm";
  };
})
