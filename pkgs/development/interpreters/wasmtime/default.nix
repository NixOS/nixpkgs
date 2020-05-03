{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "08dhk5s8rv41mjqbwfqwqmp6p6p9y7qc5yc76ljjd9l7j1phl7mr";
    fetchSubmodules = true;
  };

  cargoSha256 = "0vyxp74jlnrisk0kblsbj9d9a54wcgzbyjm7iqav1k4ns3syrnmh";

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  doCheck = false; # https://github.com/bytecodealliance/wasmtime/issues/1197

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/CraneStation/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
