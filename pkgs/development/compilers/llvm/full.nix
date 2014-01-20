{ stdenv
, fetchurl
, perl, groff
, cmake
, libxml2
, python
, libffi
, zlib
, ncurses
, isl
, gmp
, doxygen
, binutils_gold
, swig
, which
, libedit
, valgrind
}:

let
  version = "3.4";

  fetch = name: sha256: fetchurl {
    url = "http://llvm.org/releases/${version}/${name}-${version}.src.tar.gz";
    inherit sha256;
  };

  inherit (stdenv.lib) concatStrings mapAttrsToList;
in stdenv.mkDerivation {
  name = "llvm-full-${version}";

  unpackPhase = ''
    unpackFile ${fetch "llvm" "0a169ba045r4apb9cv6ncrwl83l7yiajnzirkcdlhj1cd4nn3995"}
    mv llvm-${version} llvm
    sourceRoot=$PWD/llvm
    ${concatStrings (mapAttrsToList (name: { location, sha256 }: ''
      unpackFile ${fetch name sha256}
      mv ${name}-${version} $sourceRoot/${location}
    '') {
      clang = { location = "tools/clang"; sha256 = "06rb4j1ifbznl3gfhl98s7ilj0ns01p7y7zap4p7ynmqnc6pia92"; };
      clang-tools-extra = { location = "tools/clang/tools/extra"; sha256 = "1d1822mwxxl9agmyacqjw800kzz5x8xr0sdmi8fgx5xfa5sii1ds"; };
      compiler-rt = { location = "projects/compiler-rt"; sha256 = "0p5b6varxdqn7q3n77xym63hhq4qqxd2981pfpa65r1w72qqjz7k"; };
      lld = { location = "tools/lld"; sha256 = "1sd4scqynryfrmcc4h0ljgwn2dgjmbbmf38z50ya6l0janpd2nxz"; };
      lldb = { location = "tools/lldb"; sha256 = "0h8cmjrhjhigk7k2qll1pcf6jfgmbdzkzfz2i048pkfg851s0x4g"; };
      polly = { location = "tools/polly"; sha256 = "1rqflmgzg1vzjm0r32c5ck8x3q0qm3g0hh8ggbjazh6x7nvmy6lz"; };
    })}
    sed -i 's|/usr/bin/env||' \
      $sourceRoot/tools/lldb/scripts/Python/finish-swig-Python-LLDB.sh \
      $sourceRoot/tools/lldb/scripts/Python/build-swig-Python.sh
  '';

  buildInputs = [ perl
                  groff
                  cmake
                  libxml2
                  python
                  libffi
                  zlib
                  ncurses
                  isl
                  gmp
                  doxygen
                  swig
                  which
                  libedit
                  valgrind
                ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_ENABLE_FFI=ON"
    "-DGCC_INSTALL_PREFIX=${stdenv.gcc.gcc}"
    "-DC_INCLUDE_DIRS=${stdenv.gcc.libc}/include/"
    "-DLLVM_BINUTILS_INCDIR=${binutils_gold}/include"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
  ];

  passthru.gcc = stdenv.gcc.gcc;

  enableParallelBuilding = true;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms   = stdenv.lib.platforms.all;
  };
}
