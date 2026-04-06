{
  lib,
  buildPythonPackage,
  fetchPypi,
  cargo,
  rustPlatform,
  rustc,
  typing-extensions,
  pytestCheckHook,
  hypothesis,
  inline-snapshot,
  pytest-benchmark,
  pytest-run-parallel,
  pytest-timeout,
  pytest-mock,
  dirty-equals,
  pydantic,
  typing-inspection,
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.45.0";
    pyproject = true;

    src = fetchPypi {
      pname = "pydantic_core";
      inherit version;
      hash = "sha256-o/9lkhfcs9E0Qu00jhLhLtbIdnkRVKV13vH+qbtmfY4=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-OD2nw4tf5Xt75tfp5faaWz5BjEVsFSyLSqSeEXIZWl4=";
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
      rustc
    ];

    dependencies = [ typing-extensions ];

    pythonImportsCheck = [ "pydantic_core" ];

    # escape infinite recursion with pydantic via inline-snapshot
    doCheck = false;
    passthru.tests.pytest = pydantic-core.overridePythonAttrs { doCheck = true; };

    nativeCheckInputs = [
      pytestCheckHook
      hypothesis
      inline-snapshot
      pytest-timeout
      dirty-equals
      pytest-benchmark
      pytest-mock
      pytest-run-parallel
      typing-inspection
    ];

    meta = {
      description = "Core validation logic for pydantic written in rust";
      homepage = "https://github.com/pydantic/pydantic-core";
      license = lib.licenses.mit;
      inherit (pydantic.meta) maintainers;
    };
  };
in
pydantic-core
