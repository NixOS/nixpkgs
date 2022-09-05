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
    # Adding cmake to nativeBuildInputs and using `dontUseCmakeConfigure = true;`
    # The following error still happens

    # Compiling arrow2 v0.10.1 (https://github.com/ritchie46/arrow2?branch=polars#da703ae3)
    # error[E0554]: `#![feature]` may not be used on the stable release channel
    #  --> /build/polars-0.13.19-vendor.tar.gz/arrow2/src/lib.rs:8:39
    #   |
    # 8 | #![cfg_attr(feature = "simd", feature(portable_simd))]
    #   |                                       ^^^^^^^^^^^^^
    # error: aborting due to previous error
    # For more information about this error, try `rustc --explain E0554`.
    # error: could not compile `arrow2` due to 2 previous errors
    # warning: build failed, waiting for other jobs to finish...
    #  maturin failed
    #   Caused by: Failed to build a native library through cargo
    #   Caused by: Cargo build finished with "exit status: 101": `cargo rustc --message-format json --manifest-path Cargo.toml -j 8 --frozen --target x86_64-unknown-linux-gnu --release --lib -- -C link-arg=-s`
    # error: builder for '/nix/store/qfnqi5hs3x4xdb6d4f6rpaf63n1w74yn-python3.10-polars-0.13.19.drv' failed with exit code 1;
    #        last 10 log lines:
    #        > error: aborting due to previous error
    #        >
    #        >
    #        > For more information about this error, try `rustc --explain E0554`.
    #        >
    #        > error: could not compile `arrow2` due to 2 previous errors
    #        > warning: build failed, waiting for other jobs to finish...
    #        >  maturin failed
    #        >   Caused by: Failed to build a native library through cargo
    #        >   Caused by: Cargo build finished with "exit status: 101": `cargo rustc --message-format json --manifest-path Cargo.toml -j 8 --frozen --target x86_64-unknown-linux-gnu --release --lib -- -C link-arg=-s`
    #        For full logs, run 'nix log /nix/store/qfnqi5hs3x4xdb6d4f6rpaf63n1w74yn-python3.10-polars-0.13.19.drv'.
    broken = true;
    description = "Fast multi-threaded DataFrame library in Rust | Python | Node.js ";
    homepage = "https://github.com/pola-rs/polars";
    license = licenses.asl20;
    maintainers = with maintainers; [ happysalada ];
  };
}
