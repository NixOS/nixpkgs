{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "1df99iak0psydlg9m8f8qq4zyh4wbi5l4qgsdjr2lm74ci3483xy";
    fetchSubmodules = true;
  };

  cargoSha256 = "170bz48jrc1k2ylfmd3bcry0xpcxx8p3rzzv9mprlfmrfpb0b28r";

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  # no test on darwin due to
  # https://github.com/bytecodealliance/wasmtime/issues/1556
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/CraneStation/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
