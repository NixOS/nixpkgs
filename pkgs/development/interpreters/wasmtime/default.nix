{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage {
  pname = "wasmtime";
  version = "20191111";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = "wasmtime";
    rev = "0006a2af954eba74c79885cb1fe8cdeb68f531c1";
    sha256 = "0lf3pdkjxcrjmjic7xxyjl5dka3arxi809sp9hm4hih5p2fhf2gw";
    fetchSubmodules = true;
  };

  cargoSha256 = "0mnwaipa2az3vpgbz4m9siz6bfyhmzwz174k678cv158m7mxx12f";

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAsssembly, using Cranelift";
    homepage = https://github.com/CraneStation/wasmtime;
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
