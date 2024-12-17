{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  llvm_17,
  clang_17,
  z3,
  makeWrapper,
}:

stdenv.mkDerivation {
  pname = "symcc";
  version = "1.0-unstable-2024-07-16";

  src = fetchFromGitHub {
    owner = "eurecom-s3";
    repo = "symcc";
    rev = "65a3633992318ded8939629eda54022932fd582d";
    hash = "sha256-WzZLeq+if7FyQKkSMDiqxnjtbb7eg8EVuNkCwxyEryM=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DZ3_TRUST_SYSTEM_VERSION=on"
    "-DSYMCC_RT_BACKEND=qsym"
  ];

  postPatch = ''
    echo 'install(TARGETS SymCC LIBRARY DESTINATION '\$'{CMAKE_INSTALL_LIBDIR})' >> CMakeLists.txt
  '';

  postInstall = ''
    cp SymCCRuntime-prefix/src/SymCCRuntime-build/libsymcc-rt.{a,so} $out/lib/

    install -Dm755 symcc sym++ -t $out/bin

    wrapProgram $out/bin/symcc \
      --set SYMCC_RUNTIME_DIR $out/lib \
      --set SYMCC_PASS_DIR $out/lib

    wrapProgram $out/bin/sym++ \
      --set SYMCC_RUNTIME_DIR $out/lib \
      --set SYMCC_PASS_DIR $out/lib
  '';

  nativeBuildInputs = [
    cmake
    ninja
    llvm_17
    clang_17
    makeWrapper
  ];

  buildInputs = [
    llvm_17
    z3
  ];

  meta = {
    description = "Efficient compiler-based symbolic execution";
    homepage = "https://www.s3.eurecom.fr/tools/symbolic_execution/symcc.html";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.dump_stack ];
    platforms = lib.platforms.linux;
    mainProgram = "symcc";
  };
}
