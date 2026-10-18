{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  cmake,
  pkg-config,
  zstd,
  installShellFiles,
  versionCheckHook,
  _experimental-update-script-combinators,
  nix-update-script,
  python3,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  variant ? "main",
}:
let
  sources = {
    lts-36 = {
      version = "36.0.20";
      hash = "sha256-KDqK5ri0vazHXDPyXLsNpenpRAIc/T9PQ0h+ikCIFuw=";
      cargoHash = "sha256-V9ZZdO9piR2Cn5MjND0N78G+dPQhiIGxFl9lVAtTT50=";
    };
    lts-48 = {
      version = "48.0.10";
      hash = "sha256-Pub0pqEMxmIxED/QEyz8mvyqTR7e0r40TnkZLETn8X0=";
      cargoHash = "sha256-wLU/Y2rrOGW3pucBlhgShc1/pkN1Pm9L1u7x2alFUNE=";
    };
    main = {
      version = "50.0.1";
      hash = "sha256-M9WcDyxyBYxDyzDKe2KgdPraCIQHDp1DIPH1m5emRHE=";
      cargoHash = "sha256-MIXFZtLQHDHX9e/mJMpSbzj8GlqLpTn4jYdNyw9B/uo=";
    };
  };
  source = sources.${variant};
  # there is no LTS version of python3Packages.wasmtime yet
  hasPythonBinding = variant == "main";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wasmtime";
  version = source.version;

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    tag = "v${finalAttrs.version}";
    hash = source.hash;
    fetchSubmodules = true;
  };

  # Disable cargo-auditable until https://github.com/rust-secure-code/cargo-auditable/issues/124 is solved.
  auditable = false;

  cargoHash = source.cargoHash;
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

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    installShellFiles
  ];

  buildInputs = [ zstd ];

  # The test suite compiles guest programs for the wasm32-wasip1
  # target, whose standard library is not shipped by the nixpkgs Rust
  # toolchain, and also expects wasi-sdk.
  doCheck = false;

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
    tests = lib.optionalAttrs hasPythonBinding {
      python3-wasmtime = python3.pkgs.wasmtime;
    };
    updateScript = _experimental-update-script-combinators.sequence (
      [
        (nix-update-script {
          extraArgs = [
            "--version-regex"
            "^v(\\d+\\.\\d+\\.\\d+)$"
          ];
        })
      ]
      ++ lib.optionals hasPythonBinding [
        (nix-update-script {
          attrPath = "python3.pkgs.wasmtime";
        })
      ]
    );
  };

  meta = {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://wasmtime.dev/";
    license = lib.licenses.WITH lib.licenses.asl20 lib.licenses.llvm-exception;
    mainProgram = "wasmtime";
    maintainers = with lib.maintainers; [
      ereslibre
      nekowinston
    ];
    platforms = lib.platforms.unix;
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${finalAttrs.version}/RELEASES.md";
  };
})
