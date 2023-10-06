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

buildPythonPackage rec {
  pname = "pydantic-core";
  version = "2.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "pydantic";
    repo = "pydantic-core";
    rev = "v${version}";
    hash = "sha256-Wi+b+xiJtVi3KIy6bzT29kyHFSI7mbMNrLa/Iu3cTEY=";
  };

  patches = [
    ./01-remove-benchmark-flags.patch
  ];

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
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
    description = "Core validation logic for pydantic written in rust";
    homepage = "https://github.com/pydantic/pydantic-core";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}
