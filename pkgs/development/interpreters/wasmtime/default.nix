{ rustPlatform, fetchFromGitHub, lib, v8 }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nSA78eQRbJ5JTDquaRqRgFU0V8RVCzvWUONgHxGj+Mc=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-/+uioJRXiugsV7SUwsDNHGaPxrxrhscQUGyXOzzwG/g=";

  # This environment variable is required so that when wasmtime tries
  # to run tests by using the rusty_v8 crate, it does not try to
  # download a static v8 build from the Internet, what would break
  # build hermetism.
  RUSTY_V8_ARCHIVE = "${v8}/lib/libv8.a";

  doCheck = true;
  checkFlags = [
    "--skip=cli_tests::run_cwasm"
    "--skip=commands::compile::test::test_successful_compile"
    "--skip=commands::compile::test::test_aarch64_flags_compile"
    "--skip=commands::compile::test::test_unsupported_flags_compile"
    "--skip=commands::compile::test::test_x64_flags_compile"
    "--skip=commands::compile::test::test_x64_presets_compile"
    "--skip=traps::parse_dwarf_info"
  ];

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.linux;
  };
}
