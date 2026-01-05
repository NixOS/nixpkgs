{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
    version = "2.41.5";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      tag = "v${version}";
      hash = "sha256-oIYHLSep8tWOXEaUybXG8Gv9WBoPGQ1Aj7QyqYksvMw=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-Kvc0a34C6oGc9oS/iaPaazoVUWn5ABUgrmPa/YocV+Y=";
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
      changelog = "https://github.com/pydantic/pydantic-core/releases/tag/${src.tag}";
      description = "Core validation logic for pydantic written in rust";
      homepage = "https://github.com/pydantic/pydantic-core";
      license = lib.licenses.mit;
      inherit (pydantic.meta) maintainers;
    };
  };
in
pydantic-core
