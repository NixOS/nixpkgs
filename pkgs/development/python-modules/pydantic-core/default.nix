{ stdenv
, lib
, buildPythonPackage
, fetchFromGitHub
, cargo
, rustPlatform
, rustc
, libiconv
, typing-extensions
, pytestCheckHook
, hypothesis
, pytest-timeout
, pytest-mock
, dirty-equals
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.14.5";
    format = "pyproject";

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      rev = "refs/tags/v${version}";
      hash = "sha256-UguZpA3KEutOgIavjx8Ie//0qJq+4FTZNQTwb/ZIgb8=";
    };

    patches = [
      ./01-remove-benchmark-flags.patch
    ];

    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-mMgw922QjHmk0yimXfolLNiYZntTsGydQywe7PTNnwc=";
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
      rustPlatform.maturinBuildHook
      rustc
      typing-extensions
    ];

    buildInputs = lib.optionals stdenv.isDarwin [
      libiconv
    ];

    propagatedBuildInputs = [
      typing-extensions
    ];

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
in pydantic-core
