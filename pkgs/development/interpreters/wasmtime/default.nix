<<<<<<< HEAD
{ rustPlatform, fetchFromGitHub, Security, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "12.0.1";
=======
{ rustPlatform, fetchFromGitHub, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "8.0.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-4h+c5ke4MZuIMiCaLBt6RsRe9PWAn6VqW2Z6Wnh7X30=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-SG/SFskr6ywCtJu2WVWTJC9GUKJJB0fUb+hZUaxag0M=";

  cargoBuildFlags = [ "--package" "wasmtime-cli" "--package" "wasmtime-c-api" ];
  cargoPatches = [
    # this patch is necessary until cargo-auditable is bumped on the rust platform
    ./patches/0001-Use-dep-dependency-due-to-cargo-auditable-limitation.patch
=======
    hash = "sha256-xSHwR2MGL49VDKjzAh+xYHbLz3FFg3KYVBjALVgKSQI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-A2JhjRFKPltHubiJYHBXj2H4cdU43Y2x6UjEpRGPX7U=";

  cargoBuildFlags = [
    "--package wasmtime-cli"
    "--package wasmtime-c-api"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  outputs = [ "out" "dev" ];

<<<<<<< HEAD
  buildInputs = lib.optional stdenv.isDarwin Security;

  # SIMD tests are only executed on platforms that support all
  # required processor features (e.g. SSE3, SSSE3 and SSE4.1 on x86_64):
  # https://github.com/bytecodealliance/wasmtime/blob/v9.0.0/cranelift/codegen/src/isa/x64/mod.rs#L220
  doCheck = with stdenv.buildPlatform; (isx86_64 -> sse3Support && ssse3Support && sse4_1Support);
  cargoTestFlags = ["--package" "wasmtime-runtime"];
=======
  # We disable tests on x86_64-darwin because Hydra runners do not
  # support SSE3, SSSE3, SSE4.1 and SSE4.2 at this time. This is
  # required by wasmtime. Given this is very specific to Hydra
  # runners, just disable tests on this platform, so we don't get
  # false positives of this package being broken due to failed runs on
  # Hydra (e.g. https://hydra.nixos.org/build/187667794/)
  doCheck = (stdenv.system != "x86_64-darwin");
  cargoTestFlags = [
    "--package wasmtime-runtime"
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  postInstall = ''
    # move libs from out to dev
    install -d -m 0755 $dev/lib
    install -m 0644 ''${!outputLib}/lib/* $dev/lib
    rm -r ''${!outputLib}/lib

    install -d -m0755 $dev/include/wasmtime
    install -m0644 $src/crates/c-api/include/*.h $dev/include
    install -m0644 $src/crates/c-api/include/wasmtime/*.h $dev/include/wasmtime
    install -m0644 $src/crates/c-api/wasm-c-api/include/* $dev/include
<<<<<<< HEAD
  '' + lib.optionalString stdenv.isDarwin ''
    install_name_tool -id \
      $dev/lib/libwasmtime.dylib \
      $dev/lib/libwasmtime.dylib
  '';

  meta = with lib; {
    description =
      "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://wasmtime.dev/";
    license = licenses.asl20;
    mainProgram = "wasmtime";
    maintainers = with maintainers; [ ereslibre matthewbauer ];
    platforms = platforms.unix;
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${version}/RELEASES.md";
=======
  '';

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre matthewbauer ];
    platforms = platforms.unix;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
