{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, rustPlatform
, libiconv
, fetchFromGitHub
, typing-extensions
, darwin
}:
let
  pname = "polars";
  version = "0.18.13";
  rootSource = fetchFromGitHub {
    owner = "pola-rs";
    repo = "polars";
    rev = "refs/tags/py-${version}";
    hash = "sha256-kV30r2wmswpCUmMRaFsCOeRrlTN5/PU0ogaU2JIHq0E=";
  };
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";
  disabled = pythonOlder "3.6";
  src = rootSource;

  # Cargo.lock file is sometimes behind actual release which throws an error,
  # thus the `sed` command
  # Make sure to check that the right substitutions are made when updating the package
  preBuild = ''
    cd py-polars
    #sed -i 's/version = "0.18.0"/version = "${version}"/g' Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "arrow2-0.17.3" = "sha256-pM6lNjMCpUzC98IABY+M23lbLj0KMXDefgBMjUPjDlg=";
      "jsonpath_lib-0.3.0" = "sha256-NKszYpDGG8VxfZSMbsTlzcMGFHBOUeFojNw4P2wM3qk=";
      "simd-json-0.10.0" = "sha256-0q/GhL7PG5SLgL0EETPqe8kn6dcaqtyL+kLU9LL+iQs=";
    };
  };
  cargoRoot = "py-polars";

  # Revisit this whenever package or Rust is upgraded
  RUSTC_BOOTSTRAP = 1;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
  ];

  pythonImportsCheck = [ "polars" ];
  # nativeCheckInputs = [
  #   pytestCheckHook
  #   fixtures
  #   graphviz
  #   matplotlib
  #   networkx
  #   numpy
  #   pydot
  # ];

  meta = with lib; {
    description = "Fast multi-threaded DataFrame library in Rust | Python | Node.js ";
    homepage = "https://github.com/pola-rs/polars";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
