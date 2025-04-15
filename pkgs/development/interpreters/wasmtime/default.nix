{
  lib,
  rustPlatform,
  cmake,
  fetchFromGitHub,
  Security,
  stdenv,
}:
let
  inherit (stdenv.targetPlatform.rust) cargoShortTarget;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmtime";
  version = "31.0.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IQeYmqCXhzWsuufrLKeBI2sw86dXbn7c5DbmcoJTWvo=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;
  useFetchCargoVendor = true;
  cargoHash = "sha256-zMDpbJoOaKJ974Ln43JtY3f3WOq2dEmdgX9TubYdlow=";
  cargoBuildFlags = [
    "--package"
    "wasmtime-cli"
    "--package"
    "wasmtime-c-api"
  ];

  outputs = [
    "out"
    "dev"
  ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;
  nativeBuildInputs = [ cmake ];

  doCheck =
    with stdenv.buildPlatform;
    # SIMD tests are only executed on platforms that support all
    # required processor features (e.g. SSE3, SSSE3 and SSE4.1 on x86_64):
    # https://github.com/bytecodealliance/wasmtime/blob/v9.0.0/cranelift/codegen/src/isa/x64/mod.rs#L220
    (isx86_64 -> sse3Support && ssse3Support && sse4_1Support)
    &&
      # The dependency `wasi-preview1-component-adapter` fails to build because of:
      # error: linker `rust-lld` not found
      !isAarch64;

  postInstall =
    ''
      # move libs from out to dev
      install -d -m 0755 $dev/lib
      install -m 0644 ''${!outputLib}/lib/* $dev/lib
      rm -r ''${!outputLib}/lib

      # copy the build.rs generated c-api headers
      install -d -m0755 $dev/include/wasmtime
      # https://github.com/rust-lang/cargo/issues/9661
      install -m0644 \
        target/${cargoShortTarget}/release/build/wasmtime-c-api-impl-*/out/include/*.h \
        $dev/include
      install -m0644 \
        target/${cargoShortTarget}/release/build/wasmtime-c-api-impl-*/out/include/wasmtime/*.h \
        $dev/include/wasmtime
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id \
        $dev/lib/libwasmtime.dylib \
        $dev/lib/libwasmtime.dylib
    '';

  meta = {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://wasmtime.dev/";
    license = lib.licenses.asl20;
    mainProgram = "wasmtime";
    maintainers = with lib.maintainers; [
      ereslibre
      matthewbauer
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${finalAttrs.version}/RELEASES.md";
  };
})
