{
  lib,
  anyio,
  buildPythonPackage,
  dirty-equals,
  inline-snapshot,
  opentelemetry-sdk,
  pydantic-monty-runtime,
  pytest-examples,
  pytest-pretty,
  pytestCheckHook,
  rustPlatform,
  typing-extensions,
  websockets,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-monty-client";
  inherit (pydantic-monty-runtime)
    version
    src
    cargoDeps
    cargoRoot
    ;
  pyproject = true;
  __structuredAttrs = true;

  sourceRoot = "${finalAttrs.src.name}/crates/monty-python";

  env = {
    inherit (pydantic-monty-runtime.env) CARGO_TARGET_DIR;
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ typing-extensions ];

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn10Warning"
  ];

  preCheck = ''
    cd ../..
  '';

  # Avoid importing scripts/test_fixtures.py which replaces os.environ with a mock
  enabledTestPaths = [
    "crates/monty-python/tests"
  ];

  disabledTestPaths = [
    # runs ruff from their crate inputs, but fails with lint checks
    "crates/monty-python/tests/test_readme_examples.py"
  ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    inline-snapshot
    pydantic-monty-runtime
    opentelemetry-sdk
    pytest-examples
    pytest-pretty
    pytestCheckHook
    websockets
  ];

  pythonImportsCheck = [ "pydantic_monty" ];

  meta = {
    description = "Python client for the Monty sandbox";
    homepage = "https://github.com/pydantic/monty/tree/main/crates/monty-python";
    changelog = "https://github.com/pydantic/monty/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    inherit (pydantic-monty-runtime.meta) maintainers;
  };
})
