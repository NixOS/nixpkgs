{ stdenv
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
, python
, version
, darwin
, lit
}:

stdenv.mkDerivation rec {
  pname = "lldb";
  inherit version;

  src = fetch pname "02gb3fbz09kyw8n71218v5v77ip559x3gqbcp8y3w6n3jpbryywa";

  patches = [ ./lldb-procfs.patch ];

  nativeBuildInputs = [ cmake python which swig lit ];
  buildInputs = [
    ncurses
    zlib
    libedit
    libxml2
    llvm
  ]
  ++ stdenv.lib.optionals stdenv.isDarwin [
    darwin.libobjc
    darwin.apple_sdk.libs.xpc
    darwin.apple_sdk.frameworks.Foundation
    darwin.bootstrap_cmds
    darwin.apple_sdk.frameworks.Carbon
    darwin.apple_sdk.frameworks.Cocoa
  ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
    "-DClang_DIR=${clang-unwrapped}/lib/cmake"
    "-DLLVM_EXTERNAL_LIT=${lit}/bin/lit"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    # man page
    mkdir -p $out/share/man/man1
    install ../docs/lldb.1 -t $out/share/man/man1/

    # Editor support
    # vscode:
    install -D ../tools/lldb-vscode/package.json $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/package.json
    mkdir -p $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
    ln -s $out/bin/lldb-vscode $out/share/vscode/extensions/llvm-org.lldb-vscode-0.1.0/bin
  '';

  meta = with stdenv.lib; {
    description = "A next-generation high-performance debugger";
    homepage = http://llvm.org/;
    license = licenses.ncsa;
    platforms = platforms.all;
  };
}
