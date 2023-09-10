{ rustPlatform, fetchFromGitHub, Security, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "12.0.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4h+c5ke4MZuIMiCaLBt6RsRe9PWAn6VqW2Z6Wnh7X30=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-SG/SFskr6ywCtJu2WVWTJC9GUKJJB0fUb+hZUaxag0M=";

  cargoBuildFlags = [ "--package" "wasmtime-cli" "--package" "wasmtime-c-api" ];
  cargoPatches = [
    # this patch is necessary until cargo-auditable is bumped on the rust platform
    ./patches/0001-Use-dep-dependency-due-to-cargo-auditable-limitation.patch
  ];

  outputs = [ "out" "dev" ];

  buildInputs = lib.optional stdenv.isDarwin Security;

  # SIMD tests are only executed on platforms that support all
  # required processor features (e.g. SSE3, SSSE3 and SSE4.1 on x86_64):
  # https://github.com/bytecodealliance/wasmtime/blob/v9.0.0/cranelift/codegen/src/isa/x64/mod.rs#L220
  doCheck = with stdenv.buildPlatform; (isx86_64 -> sse3Support && ssse3Support && sse4_1Support);
  cargoTestFlags = ["--package" "wasmtime-runtime"];

  postInstall = ''
    # move libs from out to dev
    install -d -m 0755 $dev/lib
    install -m 0644 ''${!outputLib}/lib/* $dev/lib
    rm -r ''${!outputLib}/lib

    install -d -m0755 $dev/include/wasmtime
    install -m0644 $src/crates/c-api/include/*.h $dev/include
    install -m0644 $src/crates/c-api/include/wasmtime/*.h $dev/include/wasmtime
    install -m0644 $src/crates/c-api/wasm-c-api/include/* $dev/include
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
  };
}
