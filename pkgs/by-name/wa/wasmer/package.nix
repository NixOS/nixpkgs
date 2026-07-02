{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  rustPlatform,
  cargo,
  rustc,
  nix-update,
  curl,
  writeShellApplication,
  installShellFiles,
  llvmPackages_22,
  libffi,
  libxml2,
  fixDarwinDylibNames,
  withLLVM ?
    stdenv.hostPlatform.isLinux || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64),
  withV8 ? (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64),
}:

let
  v8Version = "11.9.7";

  # Prebuilt V8 from wasmerio's custom builds, only evaluated when withV8 = true.

  # Per-platform hashes, auto-updated via the general updateScript
  v8Hashes = {
    "v8-linux-amd64.tar.xz" = "sha256-VOGZOKA07neIixDPJ3BLGeMX37/o9o16X4rYlo/nMbo=";
    "v8-linux-musl.tar.xz" = "sha256-drD0YfCA56zej5PFR1olfdUMOOlgYo8LGbxWEJ1NusY=";
    "v8-darwin-aarch64.tar.xz" = "sha256-Vk0ys6MjHSa8Gjd7XN0Jj4gyxORU0yP7hEmYk1ENeq4=";
  };

  v8Prebuilt =
    let
      assetName =
        if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isMusl then
          "v8-linux-musl.tar.xz"
        else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
          "v8-linux-amd64.tar.xz"
        else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
          "v8-darwin-aarch64.tar.xz"
        else
          throw "withV8 = true is not supported on ${stdenv.hostPlatform.system}";
    in
    stdenv.mkDerivation {
      name = "wasmer-v8-prebuilt-${v8Version}";
      src = fetchurl {
        url = "https://github.com/wasmerio/v8-custom-builds/releases/download/${v8Version}/${assetName}";
        hash = v8Hashes.${assetName};
      };
      sourceRoot = ".";
      dontBuild = true;
      installPhase = ''
        cp -r . $out
      '';

      meta.sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wasmer";
  version = "7.2.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HiMxBABLkX0i5jGowZU7dWhW46hvtcvbX7rskL3i+iY=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-+O/JbgozCHF/QBABMtxqkGFQYtAQwu6OUDoD5EZZmXs=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    installShellFiles
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals withLLVM [
    llvmPackages_22.llvm
    libffi
    libxml2
  ];

  postPatch =
    lib.optionalString stdenv.hostPlatform.isDarwin
      # `install -Dm644 /dev/stdin DEST` fails on darwin with
      # "skipping file '/dev/stdin', as it was replaced while being copied".
      (
        ''
          substituteInPlace Makefile \
            --replace-fail 'echo "$$pc" | install -Dm644 /dev/stdin "$(DESTDIR)"/lib/pkgconfig/wasmer.pc;' \
                           'mkdir -p "$(DESTDIR)/lib/pkgconfig" && printf "%s\n" "$$pc" > "$(DESTDIR)/lib/pkgconfig/wasmer.pc";'
        ''
        # install-capi-lib hardcodes libwasmer.so and a Linux SONAME symlink chain
        # (also marked Linux only in the Makefile)
        + ''
          substituteInPlace Makefile \
            --replace-fail 'install-capi-lib ' ""
        ''
      );

  makeFlags = [
    "WASMER_INSTALL_PREFIX=${placeholder "out"}"
    "DESTDIR=${placeholder "out"}"
    "ENABLE_LLVM=${if withLLVM then "1" else "0"}"
    "ENABLE_NAPI_V8=${if withV8 then "1" else "0"}"
  ];

  # Default all target includes headless C API which doesn't get installed
  # by their Makefile and is quite niche to include, so we opt out
  buildFlags = [
    "build-wasmer"
    "build-capi"
  ];

  env =
    lib.optionalAttrs withLLVM {
      LLVM_SYS_221_PREFIX = llvmPackages_22.llvm.dev;
    }
    // lib.optionalAttrs withV8 {
      # build.rs skips the download when these are set; see resolve_explicit_v8 in lib/napi/build.rs
      NAPI_V8_INCLUDE_DIR = "${v8Prebuilt}/include";
      V8_LIB_DIR = "${v8Prebuilt}/lib";
    };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      install -Dm755 target/release/libwasmer.dylib $out/lib/libwasmer.dylib
    ''
    + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
      # gen-completions uses argv[0] as the command name, so invoke wasmer with
      # `exec -a wasmer` to avoid baking the absolute store path into the output
      # (which produces invalid fish function names that fail to load).
      installShellCompletion --cmd wasmer \
        --bash <(exec -a wasmer $out/bin/wasmer gen-completions bash) \
        --fish <(exec -a wasmer $out/bin/wasmer gen-completions fish) \
        --zsh <(exec -a wasmer $out/bin/wasmer gen-completions zsh)
    '';

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "update-wasmer";
    runtimeInputs = [
      nix-update
      curl
    ];
    text = builtins.readFile ./update.sh;
  });

  # Tests are failing due to `Cannot allocate memory` and other reasons
  doCheck = false;

  meta = {
    sourceProvenance = with lib.sourceTypes; [ fromSource ] ++ lib.optional withV8 binaryNativeCode;
    description = "Universal WebAssembly Runtime";
    mainProgram = "wasmer";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = lib.licenses.mit;
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [
      nickcao
    ];
  };
})
