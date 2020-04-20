{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, llvmPackages
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "0.16.2";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "124zq772kz9a7n3qpxgmp4awqj41l8mhhwc0y3r77i1q02i1sy7z";
    fetchSubmodules = true;
  };

  cargoSha256 = "1qqysvcviimpm2zhzsbn8vhy91rxzaknh9hv75y38xd5ggnnh9m6";

  nativeBuildInputs = [ cmake pkg-config ];

  LIBCLANG_PATH = "${llvmPackages.libclang}/lib";

  meta = with lib; {
    description = "The Universal WebAssembly Runtime";
    longDescription = ''
      Wasmer is a standalone WebAssembly runtime for running WebAssembly outside
      of the browser, supporting WASI and Emscripten. Wasmer can be used
      standalone (via the CLI) and embedded in different languages, running in
      x86 and ARM devices.
    '';
    homepage = "https://wasmer.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ filalex77 ];
    platforms = platforms.all;
  };
}
