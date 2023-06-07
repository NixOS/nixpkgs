{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages_13
, libxml2
, ncurses
, zlib
, stdenv
}:

rustPlatform.buildRustPackage {
  pname = "bfc";
  version = "unstable-2023-02-02";

  src = fetchFromGitHub {
    owner = "Wilfred";
    repo = "bfc";
    rev = "647379de6ec36b64ba0a098589c8374d0ce32690";
    hash = "sha256-pPx9S7EnrL6aIvLlrCjGDKNYLhzd6ud1RvN+qCiZGXk=";
  };

  cargoHash = "sha256-5RPB4biLB2BTmfgOGzvnnQjnGp3cTmJdU1CVTAFRvKE=";

  buildInputs = [
    libxml2
    ncurses
    zlib
  ];

  env = {
    LLVM_SYS_130_PREFIX = llvmPackages_13.llvm.dev;
  };

  # process didn't exit successfully: <...> SIGSEGV
  doCheck = false;

  meta = with lib; {
    description = "An industrial-grade brainfuck compiler";
    homepage = "https://bfc.wilfred.me.uk";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ figsoda ];
    broken = stdenv.isAarch64 && stdenv.isLinux;
  };
}
