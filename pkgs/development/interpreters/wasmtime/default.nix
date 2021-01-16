{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    sha256 = "1zw8fa8alkxj810gq0kx01id9ankad211ax7x36kqck8ljyiazs1";
    fetchSubmodules = true;
  };

  cargoSha256 = "0wai6ki54rdnl7wlfz8dj1n2cqz9d64rfjvr3vm3cabr5dr5an43";

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  doCheck = true;

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
