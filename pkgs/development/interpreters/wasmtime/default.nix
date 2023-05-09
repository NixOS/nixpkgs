{ rustPlatform, fetchFromGitHub, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "8.0.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xSHwR2MGL49VDKjzAh+xYHbLz3FFg3KYVBjALVgKSQI=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-A2JhjRFKPltHubiJYHBXj2H4cdU43Y2x6UjEpRGPX7U=";

  cargoBuildFlags = [ "--package" "wasmtime-cli" "--package" "wasmtime-c-api" ];

  outputs = [ "out" "dev" ];

  # SIMD tests are only executed on platforms that support all
  # required processor features (e.g. SSE3, SSSE3, SSE4.1 and SSE4.2 on x86_64):
  # https://github.com/bytecodealliance/wasmtime/blob/207cd1ce15ecc504dafaec490c5eae801cac4691/cranelift/codegen/src/isa/x64/mod.rs#L228
  doCheck = with stdenv.buildPlatform; (isx86_64 -> sse3Support && ssse3Support && sse4_1Support && sse4_2Support);
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
  '';

  meta = with lib; {
    description =
      "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre matthewbauer ];
    platforms = platforms.unix;
  };
}
