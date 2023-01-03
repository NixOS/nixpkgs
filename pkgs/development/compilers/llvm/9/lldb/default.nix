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
, makeWrapper
, perl
, lit
}:

stdenv.mkDerivation rec {
  pname = "lldb";
  inherit version;

  src = fetch pname "02gb3fbz09kyw8n71218v5v77ip559x3gqbcp8y3w6n3jpbryywa";

  patches = [
    ./procfs.patch
    ./gnu-install-dirs.patch

    # Fix darwin build
    (fetchpatch {
      name = "lldb-use-system-debugserver-fix.patch";
      url = "https://github.com/llvm-mirror/lldb/commit/be770754cc43da22eacdb70c6203f4582eeb011f.diff";
      sha256 = "sha256-tKkk6sn//0Hu0nlzoKWs5fXMWc+O2JAWOEJ1ZnaLuVU=";
      excludes = [ "packages/*" ];
      postFetch = ''
        substituteInPlace "$out" --replace add_lldb_tool_subdirectory add_subdirectory
      '';
    })
    ./lldb-gdb-remote-no-libcompress.patch
  ];

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    cmake python3 which swig lit makeWrapper
  ] ++ lib.optionals stdenv.isDarwin [
    # for scripts/generate-vers.pl
    perl
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
    "-DClang_DIR=${libclang.dev}/lib/cmake"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals stdenv.isDarwin [
    # Building debugserver requires the proprietary libcompression
    "-DLLDB_USE_SYSTEM_DEBUGSERVER=ON"
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

    # man page
    mkdir -p $out/share/man/man1
    install ../docs/lldb.1 -t $out/share/man/man1/

    # Editor support
    # vscode:
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
