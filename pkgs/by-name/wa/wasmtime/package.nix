{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  cmake,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmtime";
  version = "36.0.2";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tcG78WubEm1zZXfNsDCwtw4QF5ip3ZjkxaLu8D4qBc4=";
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = "sha256-iCYZLKjO1kD753S1CiwTHa9qVxg9Y2ZMCKg0wod7GbQ=";
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

  # prevent $out from being propagated to $dev:
  # the library and header files are not dependent on the binaries
  propagatedBuildOutputs = [ ];

  postInstall =
    let
      inherit (stdenv.targetPlatform.rust) cargoShortTarget;
    in
    ''
      moveToOutput lib $dev

      # copy the build.rs generated c-api headers
      # https://github.com/rust-lang/cargo/issues/9661
      cp -r target/${cargoShortTarget}/release/build/wasmtime-c-api-impl-*/out/include $dev/include
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id \
        $dev/lib/libwasmtime.dylib \
        $dev/lib/libwasmtime.dylib
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://wasmtime.dev/";
    license = [
      lib.licenses.asl20
      lib.licenses.llvm-exception
    ];
    mainProgram = "wasmtime";
    maintainers = with lib.maintainers; [
      ereslibre
      matthewbauer
      nekowinston
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${finalAttrs.version}/RELEASES.md";
  };
})
