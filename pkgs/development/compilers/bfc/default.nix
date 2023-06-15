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
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "Wilfred";
    repo = "bfc";
    rev = version;
    hash = "sha256-pPx9S7EnrL6aIvLlrCjGDKNYLhzd6ud1RvN+qCiZGXk=";
  };

  cargoHash = "sha256-2m21FdSSFC6MsOeofHk6P4yGR3wZ3siLQTAtl4UbDBQ=";

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
