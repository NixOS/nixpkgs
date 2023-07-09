{ lib
, buildPythonPackage
, fetchFromGitHub
, cargo
, rustPlatform
, rustc
, typing-extensions
, pythonRelaxDepsHook
, pytestCheckHook
, hypothesis
, pytest-benchmark
, pytest-timeout
, pytest-mock
, dirty-equals
}:

buildPythonPackage rec {
  pname = "pydantic-core";
  version = "2.1.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-core";
    rev = "v${version}";
    hash = "sha256-JdwzCD7ppxfqf/KPMDtCyw+XaZOzyKKgd7AhtF7gVKg=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
  };

  nativeBuildInputs = [
    cargo
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    rustc
    typing-extensions
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    typing-extensions
  ];

  pythonRelaxDeps = [
    # NOTE: bumping typing-extensions to 4.7.1 would
    # cause 5000+ rebuilds at the time of submission
    #
    # TODO: remove when typing-extensions is > 4.7.0
    "typing-extensions"
  ];

  pythonImportsCheck = [ "pydantic_core" ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pytest-benchmark
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
    description = "Core validation logic for pydantic written in rust";
    homepage = "https://github.com/pydantic/pydantic-core";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
