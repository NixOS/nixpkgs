{ lib
, fetchPypi
, rustPlatform
, stdenv
, Security
, writeShellScriptBin
, buildPythonPackage
, setuptools-scm
, appdirs
, milksnake
, pyyaml
, hypothesis
, jinja2
, mock
, pytestCheckHook
}:
let
  pname = "cmsis-pack-manager";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-NeUG6PFI2eTwq5SNtAB6ZMA1M3z1JmMND29V9/O5sgw=";
  };

  native = rustPlatform.buildRustPackage {
    name = "${pname}-${version}-native";

    inherit src;

    buildInputs = lib.optionals stdenv.isDarwin [
      Security
    ];

    sourceRoot = "${pname}-${version}/rust";
    cargoLock.lockFile = ./Cargo.lock;

    postPatch = ''
      cp ${./Cargo.lock} Cargo.lock
    '';

    cargoBuildFlags = [ "--lib" ];
  };
in
buildPythonPackage rec {
  inherit pname version src;

  # The cargo build is already run in a separate derivation
  postPatch = ''
    substituteInPlace setup.py \
        --replace "'cargo', 'build'," "'true',"
  '';

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ appdirs milksnake pyyaml ];

  checkInputs = [ hypothesis jinja2 mock pytestCheckHook ];

  preBuild = ''
    mkdir -p rust/target/release/deps
    ln -s ${native}/lib/libcmsis_cffi${stdenv.hostPlatform.extensions.sharedLibrary} rust/target/release/deps/
  '';

  preCheck = ''
    # Otherwise the test uses a dummy library (missing all symbols)
    ln -sf ../build/lib/cmsis_pack_manager/_native__lib${stdenv.hostPlatform.extensions.sharedLibrary} cmsis_pack_manager/_native__lib${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  pythonImportsCheck = [ "cmsis_pack_manager" ];

  meta = with lib; {
    description = "A Rust and Python module for handling CMSIS Pack files";
    homepage = "https://github.com/pyocd/cmsis-pack-manager";
    license = licenses.asl20;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
