{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  libiconv,
  typing-extensions,
  pytestCheckHook,
  hypothesis,
  pytest-timeout,
  pytest-mock,
  dirty-equals,
  pydantic,
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.33.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      tag = "v${version}";
      hash = "sha256-2jUkd/Y92Iuq/A31cevqjZK4bCOp+AEC/MAnHSt2HLY=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit pname version src;
      hash = "sha256-MY6Gxoz5Q7nCptR+zvdABh2agfbpqOtfTtor4pmkb9c=";
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
      rustc
    ];

    build-system = [
      rustPlatform.maturinBuildHook
      typing-extensions
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

    dependencies = [ typing-extensions ];

    pythonImportsCheck = [ "pydantic_core" ];

    # escape infinite recursion with pydantic via dirty-equals
    doCheck = false;
    passthru.tests.pytest = pydantic-core.overrideAttrs { doCheck = true; };

    nativeCheckInputs = [
      pytestCheckHook
      hypothesis
      pytest-timeout
      dirty-equals
      pytest-mock
    ];

    disabledTests = [
      # RecursionError: maximum recursion depth exceeded while calling a Python object
      "test_recursive"
    ];

    disabledTestPaths = [
      # no point in benchmarking in nixpkgs build farm
      "tests/benchmarks"
    ];

    meta = with lib; {
      changelog = "https://github.com/pydantic/pydantic-core/releases/tag/v${version}";
      description = "Core validation logic for pydantic written in rust";
      homepage = "https://github.com/pydantic/pydantic-core";
      license = licenses.mit;
      maintainers = pydantic.meta.maintainers;
    };
  };
in
pydantic-core
