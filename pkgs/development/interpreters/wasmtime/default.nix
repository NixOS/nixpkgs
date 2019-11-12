{ rustPlatform, fetchFromGitHub, lib, python, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage {
  pname = "wasmtime";
  version = "20191018";

  src = fetchFromGitHub {
    owner = "CraneStation";
    repo = "wasmtime";
    rev = "ebef2c6b5720fce164af9ded8b7ff3dd5d7e041c";
    sha256 = "15wa0by7lb90qd6fg8i2v1hw7hgbkrh1rqhrf7z850c9ydah6n13";
    fetchSubmodules = true;
  };

  cargoSha256 = "07qz6wl32j6gzc9nxv0dr7y6ixmzbzv5j1flkrysdrfidxlldn9k";

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
