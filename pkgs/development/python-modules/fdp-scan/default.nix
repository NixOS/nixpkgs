{
  buildPythonPackage,
  cargo,
  hatchling,
  lib,
  protobuf,
  prototools,
  python,
  pytestCheckHook,
  rustPlatform,
  rustc,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "fdp-scan";
  inherit (prototools) version;
  pyproject = true;
  __structuredAttrs = true;

  inherit (prototools) src;
  sourceRoot = "${prototools.src.name}/fdp-scan-pyo3";

  # Cargo.lock lives at the workspace root (one level above sourceRoot).
  # cargoRoot = ".." tells cargoSetupHook to look there for Cargo.lock.
  # fetchCargoVendor gets no sourceRoot/cargoRoot so it also scans from
  # the workspace root.
  cargoRoot = "..";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-c4HxWaAaMygeUbJL9xlt80H486NTcVWHP3NeWDqXGVc=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    python # needed at build time for PYO3_PYTHON (Rust build scripts)
  ];

  buildInputs = [ python ]; # needed for linking against libpython

  env.PYO3_PYTHON = python.interpreter;

  # Compile the Rust cdylib and drop it into the fdp_scan_lib/ package
  # directory alongside the committed __init__.py and .pyi stub.
  # Hatchling (via build-system) then assembles the wheel from that directory,
  # generating .dist-info automatically — no manual installPhase needed.
  preBuild = ''
    CARGO_TARGET_DIR="$PWD/target" \
      cargo build --release --lib -p fdp_scan_lib --offline --frozen
    cp target/release/libfdp_scan_lib${stdenv.hostPlatform.extensions.sharedLibrary} \
       fdp_scan_lib/fdp_scan_lib.so
  '';

  nativeCheckInputs = [
    pytestCheckHook
    protobuf
  ];

  enabledTestPaths = [ "tests/" ];

  pythonImportsCheck = [ "fdp_scan_lib" ];

  meta = {
    description = "Rust extension for scanning binaries for embedded protobuf FileDescriptorProto blobs";
    homepage = "https://github.com/ThalesGroup/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
})
