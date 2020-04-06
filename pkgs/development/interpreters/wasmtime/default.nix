{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "v0.12.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "08dhk5s8rv41mjqbwfqwqmp6p6p9y7qc5yc76ljjd9l7j1phl7mr";
    fetchSubmodules = true;
  };

  cargoSha256 = "0wqd2yy6ih1rcz1fq7x3aiqq1ma2nmif1w8r8x0vpxjxk395zil9";

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  doCheck = false; # https://github.com/bytecodealliance/wasmtime/issues/1197

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = https://github.com/CraneStation/wasmtime;
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
