{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  buildPackages,
  cmake,
  installShellFiles,
  versionCheckHook,
  nix-update-script,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  majorVersion ? "38",
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmtime";
  version =
    {
      "29" = "29.0.1";
      "38" = "38.0.3";
    }
    .${majorVersion};

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    tag = "v${finalAttrs.version}";
    hash =
      {
        "29" = "sha256-BYTPBerWCDGqcN3TpMLhtL92f413IjCgGDQqQUu5D7Y=";
        "38" = "sha256-eszpPYtueCuAMIVrWKagS1qFCWGd0rVFTsCqRYaSGu4=";
      }
      .${majorVersion};
    fetchSubmodules = true;
  };

  cargoPatches = lib.optionals (lib.versionOlder finalAttrs.version "30") [
    (fetchpatch {
      url = "https://github.com/bytecodealliance/wasmtime/commit/73ff15fb7f758c5f88952b1a0dc36a47f2665c4e.patch";
      hash = "sha256-S8mroaw8nSTH1sExHajeYZRF0SeEUz2w+xpOxTqRMas=";
    })
  ];

  cargoHash =
    {
      "29" = "sha256-oRkZHAovgS5i8ScXpvkLYkC3x0qxwAfmBd5EPjwgyEI=";
      "38" = "sha256-agTF0GszX1f6oqo9oIPMD/GSmwbL8Ovg52TmtPq/z78=";
    }
    .${majorVersion};

  # release predates the lint, causes a build failure
  RUSTFLAGS = lib.optionalString (lib.versionOlder finalAttrs.version "30") "-Amismatched_lifetime_syntaxes";

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoBuildFlags = [
    "--package"
    "wasmtime-cli"
    "--package"
    "wasmtime-c-api"
  ];

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  nativeBuildInputs = [
    cmake
    installShellFiles
  ];

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
    let
      inherit (stdenv.hostPlatform.rust) cargoShortTarget;
    in
    ''
      moveToOutput lib $lib
      ${lib.optionalString (!enableShared) "rm -f $lib/lib/*.so{,.*}"}
      ${lib.optionalString (!enableStatic) "rm -f $lib/lib/*.a"}

      # copy the build.rs generated c-api headers
      # https://github.com/rust-lang/cargo/issues/9661
      mkdir $dev
      cp -r target/${cargoShortTarget}/release/build/wasmtime-c-api-impl-*/out/include $dev/include
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      install_name_tool -id \
        $lib/lib/libwasmtime.dylib \
        $lib/lib/libwasmtime.dylib
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd wasmtime \
        --bash <("$out/bin/wasmtime" completion bash) \
        --zsh <("$out/bin/wasmtime" completion zsh) \
        --fish <("$out/bin/wasmtime" completion fish)
    ''
    + lib.optionalString (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      installShellCompletion --cmd wasmtime \
        --bash "${buildPackages.wasmtime}"/share/bash-completion/completions/*.bash \
        --zsh "${buildPackages.wasmtime}"/share/zsh/site-functions/* \
        --fish "${buildPackages.wasmtime}"/share/fish/*/*
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
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
      nekowinston
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${finalAttrs.version}/RELEASES.md";
  };
})
