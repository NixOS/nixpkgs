{ lib, stdenv
, fetch
, cmake
, zlib
, ncurses
, swig
, which
, libedit
, libxml2
, llvm
, clang-unwrapped
, python3
, version
, darwin
, lit
, enableManpages ? false
}:

stdenv.mkDerivation (rec {
  pname = "lldb";
  inherit version;

  src = fetch pname "1vlyg015dyng43xqb8cg2l6r9ix8klibxsajazbfnckdnh54hwxj";

  patches = [ ./procfs.patch ];

  nativeBuildInputs = [ cmake python3 which swig lit ]
    ++ lib.optionals enableManpages [ python3.pkgs.sphinx python3.pkgs.recommonmark ];

  buildInputs = [
    ncurses
    zlib
    libedit
    libxml2
    llvm
  ]
  ++ lib.optionals stdenv.isDarwin [
    darwin.libobjc
    darwin.apple_sdk.libs.xpc
    darwin.apple_sdk.frameworks.Foundation
    darwin.bootstrap_cmds
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.Cocoa
  ];

  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLVM_ENABLE_RTTI=OFF"
    "-DClang_DIR=${clang-unwrapped}/lib/cmake"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
  ] ++ lib.optionals stdenv.isDarwin [
    "-DLLDB_USE_SYSTEM_DEBUGSERVER=ON"
  ] ++ lib.optionals (!stdenv.isDarwin) [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ] ++ lib.optionals enableManpages [
    "-DLLVM_ENABLE_SPHINX=ON"
    "-DSPHINX_OUTPUT_MAN=ON"
    "-DSPHINX_OUTPUT_HTML=OFF"
  ];

  postInstall = ''
    # Editor support
    # vscode:
    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/lldb-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
  '';

  meta = with lib; {
    description = "A next-generation high-performance debugger";
    homepage = "https://lldb.llvm.org";
    license = licenses.ncsa;
    platforms = platforms.all;
  };
} // lib.optionalAttrs enableManpages {
  pname = "lldb-manpages";

  buildPhase = ''
    make docs-lldb-man
  '';

  propagatedBuildInputs = [];

  installPhase = ''
    # manually install lldb man page
    mkdir -p $out/share/man/man1
    install docs/man/lldb.1 -t $out/share/man/man1/
  '';

  postPatch = null;
  postInstall = null;

  outputs = [ "out" ];

  doCheck = false;

  meta.description = "man pages for LLDB ${version}";
})
