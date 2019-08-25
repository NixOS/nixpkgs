{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "20190521";

  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasmtime";
    rev = "e530a582afe6a2b5735fd7cdf5e2e88391e58669";
    sha256 = "13lqf9dp1cnw7ms7hcgirmlfkr0v7nrn3p5g7yacfasrqgnwsyl8";
    fetchSubmodules = true;
  };

  cargoSha256 = "1jbpq09czm295316gdv3y0pfapqs0ynj3qbarwlnrv7valq5ak13";

  cargoPatches = [ ./cargo-lock.patch ];

  nativeBuildInputs = [ python cmake clang ];
  buildInputs = [ llvmPackages.libclang ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAsssembly, using Cranelift";
    homepage = https://github.com/CraneStation/wasmtime;
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
