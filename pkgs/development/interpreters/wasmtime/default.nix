{ rustPlatform, fetchFromGitHub, lib, v8 }:

rustPlatform.buildRustPackage rec {
  pname = "wasmtime";
  version = "0.35.2";

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4oZglk7MInLIsvbeCfs4InAcmSmzZp16XL5+8eoYXJk=";
    fetchSubmodules = true;
  };

  cargoSha256 = "sha256-IqFOw9bGdM3IEoMeqDlxKfLnZvR80PSnwP9kr1tI/h0=";

  nativeBuildInputs = [ python3 cmake clang ];
  buildInputs = [ llvmPackages.libclang ] ++
   lib.optionals stdenv.isDarwin [ darwin.apple_sdk.frameworks.Security ];
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";

  configurePhase = ''
    export HOME=$TMP;
  '';

  doCheck = true;

  meta = with lib; {
    description = "Standalone JIT-style runtime for WebAssembly, using Cranelift";
    homepage = "https://github.com/bytecodealliance/wasmtime";
    license = licenses.asl20;
    maintainers = [ maintainers.matthewbauer ];
    platforms = platforms.unix;
  };
}
