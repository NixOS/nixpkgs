{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, rustPlatform
, libiconv
, fetchzip
, typing-extensions
}:
let
  pname = "polars";
  version = "0.15.13";
  rootSource = fetchzip {
    url = "https://github.com/pola-rs/${pname}/archive/refs/tags/py-${version}.tar.gz";
    hash = "sha256-bk2opNLN3L+fkzXVfUU5O37UmA27ijmnAElCHjsuI+o=";
  };
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";
  disabled = pythonOlder "3.6";
  src = rootSource;

  # Cargo.lock files is sometimes behind actual release which throws an error,
  # thus the `sed` command
  # Make sure to check that the right substitutions are made when updating the package
  preBuild = ''
      cd py-polars
      sed -i 's/version = "0.15.11"/version = "${version}"/g' Cargo.lock
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = rootSource;
    preBuild = ''
        cd py-polars
    '';
    name = "${pname}-${version}";
    hash = "sha256-u7ascftUPz8K+gWwjjxdXXFJf++M+8P9QE/KVJkO5DM=";
  };
  cargoRoot = "py-polars";

  # Revisit this whenever package or Rust is upgraded
  RUSTC_BOOTSTRAP = 1;

  propagatedBuildInputs = lib.optionals (pythonOlder "3.10") [ typing-extensions ];

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
