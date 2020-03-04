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
, perl
, python3
, version
, darwin
}:

stdenv.mkDerivation {
  pname = "lldb";
  inherit version;

  src = fetch "lldb" "0klsscg1sczc4nw2l53xggi969k361cng2sjjrfp3bv4g5x14s4v";

  nativeBuildInputs = [ cmake perl python3 which swig ];
  buildInputs = [ ncurses zlib libedit libxml2 llvm ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.libobjc darwin.apple_sdk.libs.xpc darwin.apple_sdk.frameworks.Foundation darwin.bootstrap_cmds darwin.apple_sdk.frameworks.Carbon darwin.apple_sdk.frameworks.Cocoa ];


  postPatch = ''
    # Fix up various paths that assume llvm and clang are installed in the same place
    sed -i 's,".*ClangConfig.cmake","${clang-unwrapped}/lib/cmake/clang/ClangConfig.cmake",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,".*tools/clang/include","${clang-unwrapped}/include",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,"$.LLVM_LIBRARY_DIR.",${llvm}/lib ${clang-unwrapped}/lib,' \
      cmake/modules/LLDBStandalone.cmake
    sed -i -e 's,message(SEND_ERROR "Cannot find debugserver on system."),,' \
           -e 's,string(STRIP ''${XCODE_DEV_DIR} XCODE_DEV_DIR),,' \
           tools/debugserver/source/CMakeLists.txt

    # Fix /usr/bin references for sandboxed builds.
    patchShebangs scripts
  '';

  cmakeFlags = [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
    "-DSKIP_DEBUGSERVER=ON"
  ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang "-I${libxml2.dev}/include/libxml2";

  enableParallelBuilding = true;

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp ../docs/lldb.1 $out/share/man/man1/
  '';

  meta = with stdenv.lib; {
    description = "A next-generation high-performance debugger";
    homepage    = http://llvm.org/;
    license     = licenses.ncsa;
    platforms   = platforms.all;
  };
}
