{
  buildPythonPackage,
  cargo,
  hatchling,
  lib,
  prototools,
  python,
  pytestCheckHook,
  pythonProtobuf, # Python protobuf library (google.protobuf) for tests
  rustPlatform,
  rustc,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "prototext-codec";
  inherit (prototools) version;
  pyproject = true;
  __structuredAttrs = true;

  inherit (prototools) src;
  sourceRoot = "${prototools.src.name}/prototext-pyo3";

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

  # prototext-core's build.rs checks DESCRIPTOR_PB (and siblings) first;
  # when set, it copies the .pb files directly from those store paths into
  # OUT_DIR, bypassing the fixtures/prebuilt/ fallback (which is read-only
  # in the Nix sandbox).  prototools.fixtures is a separate derivation that
  # runs protoc once and caches the results in the Nix store.
  env.DESCRIPTOR_PB = "${prototools.fixtures}/descriptor.pb";
  env.KNIFE_PB = "${prototools.fixtures}/knife.pb";
  env.ENUM_COLLISION_PB = "${prototools.fixtures}/enum_collision.pb";
  env.MESSAGE_SET_PB = "${prototools.fixtures}/message_set.pb";

  preBuild = ''
    CARGO_TARGET_DIR="$PWD/target" \
      cargo build --release --lib -p prototext_codec_lib --offline --frozen
    cp target/release/libprototext_codec_lib${stdenv.hostPlatform.extensions.sharedLibrary} \
       prototext_codec_lib/prototext_codec_lib.so
  '';

  nativeCheckInputs = [
    pytestCheckHook
    pythonProtobuf
  ];

  enabledTestPaths = [ "tests/" ];

  pythonImportsCheck = [ "prototext_codec_lib" ];

  meta = {
    description = "Lossless protobuf decoder Python extension (PyO3)";
    homepage = "https://github.com/ThalesGroup/prototools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ douzebis ];
  };
})
