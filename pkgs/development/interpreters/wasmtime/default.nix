{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "v0.8.0";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "0az893srw49szvs5461bd165ffla4cc98gh42p3dwskwfkhpqjm4";
    fetchSubmodules = true;
  };

  cargoSha256 = "08b3rbnl7qwyfbwaqcb7z84sh0h94v18v6557hrf0dlil414v54i";

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = https://github.com/CraneStation/wasmtime;
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
