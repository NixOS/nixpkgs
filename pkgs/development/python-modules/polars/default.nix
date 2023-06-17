{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, rustPlatform
, libiconv
, fetchFromGitHub
, typing-extensions
}:
let
  pname = "polars";
  version = "0.17.11";
  rootSource = fetchFromGitHub {
    owner = "pola-rs";
    repo = "polars";
    rev = "refs/tags/py-${version}";
    hash = "sha256-zNp/77an9daUfHQ+HCaHtZzaq0TT9F+8aH3abrF7+YA=";
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
      #sed -i 's/version = "0.17.11"/version = "${version}"/g' Cargo.lock
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "arrow2-0.17.0" = "sha256-jjrwTP+ZKem9lyrmAWJ+t9cZBkGqAR1VlgNFXDtx1LA=";
      "jsonpath_lib-0.3.0" = "sha256-NKszYpDGG8VxfZSMbsTlzcMGFHBOUeFojNw4P2wM3qk=";
      "simd-json-0.7.0" = "sha256-tlz6my4vhUQIArPonJml8zIyk1sbbDSORKp3cmPUUSI=";
    };
  };
  cargoRoot = "py-polars";

  # Revisit this whenever package or Rust is upgraded
  RUSTC_BOOTSTRAP = 1;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.11") [ typing-extensions ];

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

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
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Fast multi-threaded DataFrame library in Rust | Python | Node.js ";
    homepage = "https://github.com/pola-rs/polars";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
