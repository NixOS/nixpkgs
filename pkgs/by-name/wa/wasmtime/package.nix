{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  buildPackages,
  cmake,
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
      version = "36.0.14";
      hash = "sha256-OI8wixfzV4U2brmW7uqhk55eLhj+Fdp+J5Pzz1iBO6U=";
      cargoHash = "sha256-2Nwcw3Z4/cbkRcG2hJ2/1PcXZf3vYB9NGUlr7pxdqzU=";
    };
    main = {
      version = "48.0.1";
      hash = "sha256-nvDiKIyo0/BmwjPTfNGIX1kSVVJQbmjjT4qed0dr8cc=";
      cargoHash = "sha256-NVea5PiuFTr1NrIcyEJSq0gFf2XkDZj/VKubHwO34U4=";
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
