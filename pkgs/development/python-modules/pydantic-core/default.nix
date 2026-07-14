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
    version = "2.46.4";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic";
      tag = "core-v${version}";
      hash = "sha256-G4Xo6BF6tOn4g/qG3RNDP3/+lYnCOuw3AB1OrVOGcSA=";
    };

    sourceRoot = "${src.name}/pydantic-core";

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit
        pname
        version
        src
        sourceRoot
        ;
      hash = "sha256-5L317YTV7/Bc/YJLLzc745oJntiYkcZupdeUxiQwcOU=";
    };

    nativeBuildInputs = [
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
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
      homepage = "https://github.com/pydantic/pydantic/tree/main/pydantic-core";
      license = lib.licenses.mit;
      inherit (pydantic.meta) maintainers;
    };
  };
in
pydantic-core
