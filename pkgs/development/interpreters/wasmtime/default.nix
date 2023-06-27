{ rustPlatform, fetchFromGitHub, Security, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "10.0.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UqjJVAmqITh7ixo71jfdQNZ5OLjmmmrk4b0saU2kyYo=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-fEDvxstvBP/e2G8KbTVQKdxafQXxz4mnqCAso16HYaY=";

  cargoBuildFlags = [ "--package" "wasmtime-cli" "--package" "wasmtime-c-api" ];

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
    maintainers = with maintainers; [ ereslibre matthewbauer ];
    platforms = platforms.unix;
    changelog = "https://github.com/bytecodealliance/wasmtime/blob/v${version}/RELEASES.md";
  };
}
