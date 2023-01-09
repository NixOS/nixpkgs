{ rustPlatform, fetchFromGitHub, lib, stdenv }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Vw3+KlAuCQiyBfPOZrUotgrdkG+FRjXg8AxAanfbwJQ=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-gV3Yf7YL3D3hrymYW1b80uOlp7RYRWFC7GtxAot5Ut0=";

  cargoBuildFlags = [
    "--package wasmtime-cli"
    "--package wasmtime-c-api"
  ];

  outputs = [ "out" "dev" ];

  # We disable tests on x86_64-darwin because Hydra runners do not
  # support SSE3, SSSE3, SSE4.1 and SSE4.2 at this time. This is
  # required by wasmtime. Given this is very specific to Hydra
  # runners, just disable tests on this platform, so we don't get
  # false positives of this package being broken due to failed runs on
  # Hydra (e.g. https://hydra.nixos.org/build/187667794/)
  doCheck = (stdenv.system != "x86_64-darwin");
  checkFlags = [
    "--skip=cli_tests::run_cwasm"
    "--skip=commands::compile::test::test_unsupported_flags_compile"
    "--skip=commands::compile::test::test_aarch64_flags_compile"
    "--skip=commands::compile::test::test_successful_compile"
    "--skip=commands::compile::test::test_x64_flags_compile"
    "--skip=commands::compile::test::test_x64_presets_compile"
    "--skip=traps::parse_dwarf_info"
  ];

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
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre matthewbauer ];
    platforms = platforms.unix;
  };
}
