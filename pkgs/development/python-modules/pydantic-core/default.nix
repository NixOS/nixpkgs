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
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.27.2";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      tag = "v${version}";
      hash = "sha256-dGef0WflrjktAxukT8TEZhq1mrkXjcz5UE7FNQ0RINU=";
    };

    patches = [ ./01-remove-benchmark-flags.patch ];

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-DC25ABR31bntUacPhqdPqoR743aH1U8nnkpC1mk3Avw=";
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
      maintainers = with maintainers; [ blaggacao ];
    };
  };
in
pydantic-core
