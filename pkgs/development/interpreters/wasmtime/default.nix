{ rustPlatform, fetchFromGitHub, lib, python3, cmake, llvmPackages, clang, stdenv, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.34.1";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-GrysmFPdSoS7BVK8UVv0R1KBgh3Yu0chNNKbODxhIw8=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-Nb+45pkXWRCuggxVdMtC5TsKl85eolNWskrTPKFuR4I=";

  nativeBuildInputs = [ python3 cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  cargoBuildFlags = [ "--package wasmtime-cli --package wasmtime-c-api" ];

  outputs = [ "out" "dev" ];

  postInstall = ''
    # move libs from out to dev
    install -d -m755 $dev/lib
    install -m644 $out/lib/*.a $dev/lib
    install -m755 $out/lib/*.so $dev/lib
    rm -r $out/lib

    install -d -m744 $dev/include/wasmtime
    install -m644 $src/crates/c-api/include/*.h $dev/include
    install -m644 $src/crates/c-api/include/wasmtime/*.h $dev/include/wasmtime
    install -m644 $src/crates/c-api/wasm-c-api/include/* $dev/include
  '';

  doCheck = false;

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
