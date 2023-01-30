{ lib, stdenv, llvm_meta
, fetch
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
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "lldb";
  inherit version;

  src = fetch "lldb" "1mriw4adrwm6kzabrjr7yqmdiylxd6glf6samd80dp8idnm9p9z8";

  patches = [
    ./gnu-install-dirs.patch

    # Fix darwin build
    ./lldb-gdb-remote-no-libcompress.patch
  ];

  postPatch = ''
    # Fix up various paths that assume llvm and clang are installed in the same place
    sed -i 's,".*ClangConfig.cmake","${libclang.dev}/lib/cmake/clang/ClangConfig.cmake",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,".*tools/clang/include","${libclang.dev}/include",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,"$.LLVM_LIBRARY_DIR.",${libllvm.lib}/lib ${libclang.lib}/lib,' \
      cmake/modules/LLDBStandalone.cmake

    substituteInPlace tools/CMakeLists.txt \
      --replace "add_subdirectory(debugserver)" ""
  '';

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    cmake python3 which swig makeWrapper
  ];

  buildInputs = [
    ncurses zlib libedit libxml2 libllvm
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
    darwin.apple_sdk.libs.xpc
    darwin.apple_sdk.frameworks.Foundation
    darwin.bootstrap_cmds
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.Cocoa
    darwin.apple_sdk.frameworks.DebugSymbols
  ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_INCLUDE_TESTS=${if doCheck then "YES" else "NO"}"
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals stdenv.isDarwin [
    # Building debugserver requires the proprietary libcompression
    "-DLLDB_NO_DEBUGSERVER=ON"
  ] ++ lib.optionals doCheck [
    "-DLLDB_TEST_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "-DLLDB_TEST_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = false;

  installCheckPhase = ''
    if [ ! -e "$lib/${python3.sitePackages}/lldb/_lldb.so" ] ; then
        return 1;
    fi
  '';

  postInstall = ''
    wrapProgram $out/bin/lldb --prefix PYTHONPATH : $lib/${python3.sitePackages}/

    mkdir -p $out/share/man/man1
    cp ../docs/lldb.1 $out/share/man/man1/

    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/llvm-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
  '';

  meta = llvm_meta // {
    broken = stdenv.isDarwin && stdenv.isAarch64;
    homepage = "https://lldb.llvm.org/";
    description = "A next-generation high-performance debugger";
    longDescription = ''
      LLDB is a next generation, high-performance debugger. It is built as a set
      of reusable components which highly leverage existing libraries in the
      larger LLVM Project, such as the Clang expression parser and LLVM
      disassembler.
    '';
  };
}
