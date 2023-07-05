{ stdenv
, fetchFromGitHub
, cmake
, ninja
, lib
}:

stdenv.mkDerivation {
  pname = "asmjit";
  version = "unstable-2022-11-10";

  src = fetchFromGitHub {
    owner = "asmjit";
    repo = "asmjit";
    rev = "0c03ed2f7497441ac0de232bda2e6b8cc041b2dc";
    hash = "sha256-CfTtdgb+ZCLHwCRa+t2O4CG9rhHgqPLcfHDqLBvI9Tg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  strictDeps = true;

  meta = with lib; {
    description = "Machine code generation for C++";
    longDescription = ''
      AsmJit is a lightweight library for machine code generation written in
      C++ language. It can generate machine code for X86, X86_64, and AArch64
      architectures and supports baseline instructions and all recent
      extensions.
    '';
    homepage = "https://asmjit.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ nikstur ];
  };
}
