{ lib, stdenv, llvm_meta
, runCommand
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
, libobjc
, xpc
, Foundation
, bootstrap_cmds
, Carbon
, Cocoa
, lit
, enableManpages ? false
}:

stdenv.mkDerivation (rec {
  pname = "lldb";
  inherit version;

  src = fetch pname "1v85qyq3snk81vjmwq5q7xikyyqsfpqy2c4qmr81mps4avsw1g0l";

  patches = [
    ./procfs.patch
    (runCommand "resource-dir.patch" {
      clangLibDir = "${libclang.lib}/lib";
    } ''
      substitute '${./resource-dir.patch}' "$out" --subst-var clangLibDir
    '')
    ./gnu-install-dirs.patch
  ];

  outputs = [ "out" "lib" "dev" ];

  nativeBuildInputs = [
    cmake python3 which swig lit
  ] ++ lib.optionals enableManpages [
    python3.pkgs.sphinx python3.pkgs.recommonmark
  ];

  buildInputs = [
    ncurses
    zlib
    libedit
    libxml2
    libllvm
  ]
  ++ lib.optionals stdenv.isDarwin [
    libobjc
    xpc
    Foundation
    bootstrap_cmds
    Carbon
    Cocoa
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_INCLUDE_TESTS=${if doCheck then "YES" else "NO"}"
    "-DLLVM_ENABLE_RTTI=OFF"
    "-DClang_DIR=${libclang.dev}/lib/cmake"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DLLDB_USE_SYSTEM_DEBUGSERVER=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals enableManpages [
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
  ] ++ lib.optionals doCheck [
    "-DLLDB_TEST_C_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}cc"
    "-DLLDB_TEST_CXX_COMPILER=${stdenv.cc}/bin/${stdenv.cc.targetPrefix}c++"
  ];

  doCheck = false;

  postInstall = ''
    # Editor support
    # vscode:
    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/lldb-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
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
  };
} // lib.optionalAttrs enableManpages {
  pname = "lldb-manpages";

  buildPhase = ''
    make docs-lldb-man
  '';

  propagatedBuildInputs = [];

  # manually install lldb man page
  installPhase = ''
    mkdir -p $out/share/man/man1
    install docs/man/lldb.1 -t $out/share/man/man1/
  '';

  postPatch = null;
  postInstall = null;

  outputs = [ "out" ];

  doCheck = false;

  meta = llvm_meta // {
    description = "man pages for LLDB ${version}";
  };
})
