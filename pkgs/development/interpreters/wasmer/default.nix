{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, llvmPackages
, pkg-config
}:

rustPlatform.buildRustPackage rec {
  pname = "wasmer";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "wasmerio";
    repo = pname;
    rev = version;
    sha256 = "05g4h0xkqd14wnmijiiwmhk6l909fjxr6a2zplrjfxk5bypdalpm";
    fetchSubmodules = true;
  };

  cargoSha256 = "1ssmgx9fjvkq7ycyzjanqmlm5b80akllq6qyv3mj0k5fvs659wcq";

  nativeBuildInputs = [ cmake pkg-config ];

  # Since wasmer 0.17 no backends are enabled by default. Backends are now detected
  # using the [makefile](https://github.com/wasmerio/wasmer/blob/master/Makefile).
  # Enabling cranelift as this used to be the old default. At least one backend is
  # needed for the run subcommand to work.
  cargoBuildFlags = [ "--features 'backend-cranelift'" ];

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
    maintainers = with maintainers; [ Br1ght0ne ];
  };
}
