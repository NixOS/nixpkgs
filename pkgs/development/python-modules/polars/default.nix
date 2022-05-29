{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, rustPlatform
, libiconv
, fetchzip
}:
let
  pname = "polars";
  version = "0.13.19";
  rootSource = fetchzip {
    url = "https://github.com/pola-rs/${pname}/archive/refs/tags/py-polars-v${version}.tar.gz";
    sha256 = "sha256-JOHjxTTPzS9Dd/ODp4r0ebU9hEonxrbjURJoq0BQCyI=";
  };
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";
  disabled = pythonOlder "3.6";
  src = rootSource;
  preBuild = ''
      cd py-polars
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = rootSource;
    preBuild = ''
        cd py-polars
    '';
    name = "${pname}-${version}";
    sha256 = "sha256-KEt8lITY4El2afuh2cxnrDkXGN3MZgfKQU3Pe2jECF0=";
  };
  cargoRoot = "py-polars";

  nativeBuildInputs = with rustPlatform; [ cargoSetupHook maturinBuildHook ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  pythonImportsCheck = [ "polars" ];
  # checkInputs = [
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
