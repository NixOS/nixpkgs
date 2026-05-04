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
  llvmPackages_21,
  libffi,
  libxml2,
  withLLVM ?
    stdenv.hostPlatform.isLinux || (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64),
  withV8 ? (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64),
}:

let
  v8Version = "11.9.2";

  # Prebuilt V8 from wasmerio's custom builds, only evaluated when withV8 = true.

  # Per-platform hashes, auto-updated via the general updateScript
  v8Hashes = {
    "v8-linux-amd64.tar.xz" = "sha256-nTCVdBKtyVMb7lE+Db4RDsShKkLbG/0r980ejd+EAvo=";
    "v8-linux-musl-amd64.tar.xz" = "sha256-XgRs3I46B2PG7Jrv5E+KSeuNfXLhgB7R66cAkA/Bvv8=";
    "v8-darwin-arm64.tar.xz" = "sha256-xAG1PcAGw8a0A9k8d78/whTUXnqdfRZBz8yrg/+iz0M=";
  };

  v8Prebuilt =
    let
      assetName =
        if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isMusl then
          "v8-linux-musl-amd64.tar.xz"
        else if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64 then
          "v8-linux-amd64.tar.xz"
        else if stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64 then
          "v8-darwin-arm64.tar.xz"
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
  version = "7.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = "wasmer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A1SkZY+iSR9xlu6R1p9uZYsGFPAOifuYTHtEXaEgves=";
    fetchSubmodules = true;
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-wBEwGKjj9DdZESFlXS8T7B0Xdp7yMe08DYTGr4wnTVI=";
  };

  nativeBuildInputs = [
    cargo
    rustc
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
  ];

  buildInputs = lib.optionals withLLVM [
    llvmPackages_21.llvm
    libffi
    libxml2
  ];

  # In 7.1.0 there is no nice flag to toggle napi/v8 on or off,
  # so we manually delete the Makefile entry when we don't want v8
  # TODO: v7.2.0 pre-release has a flag, when updating to 7.2.0
  #  add "ENABLE_NAPI_V8=${if withV8 then "1" else "0"}" to makeFlags
  postPatch =
    lib.optionalString (!withV8) ''
      substituteInPlace Makefile \
        --replace-fail '	build_wasmer_extra_features += napi-v8' ""
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace Makefile \
        --replace-fail 'install: install-wasmer install-capi-headers install-capi-lib install-pkgconfig install-misc' \
                       'install: install-wasmer install-capi-headers install-misc'
    '';

  makeFlags = [
    "WASMER_INSTALL_PREFIX=${placeholder "out"}"
    "DESTDIR=${placeholder "out"}"
    "ENABLE_LLVM=${if withLLVM then "1" else "0"}"
  ];

  # Default all target includes headless C API which doesn't get installed
  # by their Makefile and is quite niche to include, so we opt out
  buildFlags = [
    "build-wasmer"
    "build-capi"
  ];

  env =
    lib.optionalAttrs withLLVM {
      LLVM_SYS_211_PREFIX = llvmPackages_21.llvm.dev;
    }
    // lib.optionalAttrs withV8 {
      # build.rs skips the download when these are set; see resolve_explicit_v8 in lib/napi/build.rs
      NAPI_V8_INCLUDE_DIR = "${v8Prebuilt}/include";
      V8_LIB_DIR = "${v8Prebuilt}/lib";
    };

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm755 target/release/libwasmer.dylib $out/lib/libwasmer.dylib
    if pc="$(WASMER_DIR="" target/release/wasmer config --pkg-config 2>/dev/null)"; then
      mkdir -p "$out/lib/pkgconfig"
      printf '%s\n' "$pc" > "$out/lib/pkgconfig/wasmer.pc"
    fi
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
