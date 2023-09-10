{ lib
, rustPlatform
, fetchFromGitHub
, llvmPackages_13
, libxml2
, ncurses
, zlib
, stdenv
}:

rustPlatform.buildRustPackage rec {
  pname = "bfc";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Wilfred";
    repo = "bfc";
    rev = version;
    hash = "sha256-uRQP3LS7cpG85BilkSaI+2WbEp/6zZcFrryMNO+n6EA=";
  };

  cargoHash = "sha256-aQLUZzHBy5CBbp5SpsS5dFQYpD7Bc+4zTfLjA/nmMnE=";

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
