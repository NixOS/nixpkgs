{ lib, stdenv
, fetch
, fetchpatch
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
}:

stdenv.mkDerivation {
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
  ];

  postPatch = ''
    # Fix up various paths that assume llvm and clang are installed in the same place
    sed -i 's,".*ClangConfig.cmake","${clang-unwrapped}/lib/cmake/clang/ClangConfig.cmake",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,".*tools/clang/include","${clang-unwrapped}/include",' \
      cmake/modules/LLDBStandalone.cmake
    sed -i 's,"$.LLVM_LIBRARY_DIR.",${llvm}/lib ${clang-unwrapped}/lib,' \
      cmake/modules/LLDBStandalone.cmake
  '';

  nativeBuildInputs = [ cmake python3 which swig ];
  buildInputs = [ ncurses zlib libedit libxml2 llvm ]
    ++ lib.optionals stdenv.isDarwin [ darwin.libobjc darwin.apple_sdk.libs.xpc darwin.apple_sdk.frameworks.Foundation darwin.bootstrap_cmds darwin.apple_sdk.frameworks.Carbon darwin.apple_sdk.frameworks.Cocoa ];

  CXXFLAGS = "-fno-rtti";
  hardeningDisable = [ "format" ];

  cmakeFlags = [
    "-DLLDB_CODESIGN_IDENTITY=" # codesigning makes nondeterministic
  ];

  postInstall = ''
    mkdir -p $out/share/man/man1
    cp ../docs/lldb.1 $out/share/man/man1/
  '';

  meta = with lib; {
    description = "A next-generation high-performance debugger";
    homepage    = "https://llvm.org/";
    license     = licenses.ncsa;
    platforms   = platforms.all;
  };
}
