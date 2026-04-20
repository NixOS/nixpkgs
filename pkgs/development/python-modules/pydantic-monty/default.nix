{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  rustPlatform,

  anyio,
  dirty-equals,
  inline-snapshot,
  pytest-examples,
  pytest-pretty,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-monty";
  version = "0.0.13";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "monty";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0g0/NuwTuUfHVHE8YcVjUeZpSa+ANPWIXllu+qRXjZE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-LkTEMhz0MG6RfqejOQMdB2BZU6oxT3ZAo/N0oVlswsQ=";
  };

  dependencies = [ typing-extensions ];

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  maturinBuildFlags = [
    "-m"
    "crates/monty-python/Cargo.toml"
  ];

  pytestFlags = [
    "--config-file"
    "crates/monty-python/pyproject.toml"
  ];

  disabledTests = [
    # These tests fails because they expect to have multiple cores
    # to produce a predicted speedup measurement, which we cannot
    # achieve in the sandbox.
    "test_parallel_exec"
  ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    inline-snapshot
    pytest-examples
    pytest-pretty
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pydantic_monty" ];

  meta = {
    description = "Minimal, secure Python interpreter written in Rust for use by AI";
    homepage = "https://github.com/pydantic/monty";
    changelog = "https://github.com/pydantic/monty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ squat ];
  };
})
