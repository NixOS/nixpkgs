{ lib, stdenv, llvm_meta
, fetch
, fetchpatch
, cmake
, zlib
, ncurses
, swig
, which
, libedit
, libxml2
, libllvm
, libclang
, python3
, version
, darwin
}:

stdenv.mkDerivation rec {
  pname = "lldb";
  inherit version;

  src = fetch "lldb" "05j2a63yzln43852nng8a7y47spzlyr1cvdmgmbxgd29c8r0bfkq";

  patches = [
    # Fix PythonString::GetString for >=python-3.7
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/5457b426f5e15a29c0acc8af1a476132f8be2a36.patch";
      sha256 = "1zbx4m0m8kbg0wq6740jcw151vb2pb1p25p401wiq8diqqagkjps";
      stripLen = 1;
    })
    ./gnu-install-dirs.patch
  ];

  postPatch = ''
    # Fix up various paths that assume llvm and clang are installed in the same place
    sed -i 's,".*ClangConfig.cmake","${libclang.dev}/lib/cmake/clang/ClangConfig.cmake",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,".*tools/clang/include","${libclang.dev}/include",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,"$.LLVM_LIBRARY_DIR.",${libllvm.lib}/lib ${libclang.lib}/lib,' \
      cmake/modules/LLDBStandalone.cmake
  '';

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    cmake python3 which swig
  ];

  buildInputs = [
    ncurses zlib libedit libxml2 libllvm
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
    darwin.apple_sdk.libs.xpc
    darwin.apple_sdk.frameworks.Foundation darwin.bootstrap_cmds darwin.apple_sdk.frameworks.Carbon darwin.apple_sdk.frameworks.Cocoa
  ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_INCLUDE_TESTS=${if doCheck then "YES" else "NO"}"
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals doCheck [
    "-DLLDB_TEST_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "-DLLDB_TEST_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = false;

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp ../docs/lldb.1 $out/share/man/man1/
  '';

  meta = llvm_meta // {
    homepage = "https://lldb.llvm.org/";
    description = "A next-generation high-performance debugger";
    longDescription = ''
      LLDB is a next generation, high-performance debugger. It is built as a set
      of reusable components which highly leverage existing libraries in the
      larger LLVM Project, such as the Clang expression parser and LLVM
      disassembler.
    '';
    # never built on aarch64-darwin since first introduction in nixpkgs
    broken = stdenv.isDarwin && stdenv.isAarch64;
  };
}
