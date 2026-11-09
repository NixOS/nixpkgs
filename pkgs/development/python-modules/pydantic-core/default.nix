{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  typing-extensions,
  pytestCheckHook,
  hypothesis,
  inline-snapshot,
  pytest-benchmark,
  pytest-examples,
  pytest-run-parallel,
  pytest-timeout,
  pytest-mock,
  dirty-equals,
  pydantic,
  typing-inspection,
}:

buildPythonPackage (finalAttrs: {
  pname = "pydantic-core";
  version = "2.50.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic";
    tag = "core-v${finalAttrs.version}";
    hash = "sha256-Q5dvfgbbYw3QeB1nY+eUIBoVsUpxgLKE8jTX6CJV+Zs=";
  };

  sourceRoot = "${finalAttrs.src.name}/pydantic-core";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    hash = "sha256-AHOFlhGY5ka6wFl4LmhBbmie1einzoyMde7YJ5yWhzw=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  dependencies = [ typing-extensions ];

  pythonImportsCheck = [ "pydantic_core" ];

  # escape infinite recursion with pydantic via inline-snapshot
  doCheck = false;
  passthru = {
    # bulk updater uses wrong tag
    skipBulkUpdate = true;
    tests.pytest = finalAttrs.overrideAttrs { doInstallCheck = true; };
  };

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    inline-snapshot
    pytest-timeout
    dirty-equals
    pytest-benchmark
    pytest-examples
    pytest-mock
    pytest-run-parallel
    typing-inspection
  ];

  meta = {
    description = "Core validation logic for pydantic written in rust";
    homepage = "https://github.com/pydantic/pydantic/tree/main/pydantic-core";
    license = lib.licenses.mit;
    inherit (pydantic.meta) maintainers;
  };
})
