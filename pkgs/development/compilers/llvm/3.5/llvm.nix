{ stdenv
, fetch
, fetchpatch
, perl
, groff
, cmake
, python
, libffi
, libbfd
, libxml2
, valgrind
, ncurses
, version
, zlib
, compiler-rt_src
, debugVersion ? false
, enableSharedLibraries ? !stdenv.isDarwin
}:

let
  src = fetch "llvm" "0xf5q17kkxsrm2gsi93h4pwlv663kji73r2g4asb97klsmb626a4";
in stdenv.mkDerivation rec {
  name = "llvm-${version}";

  unpackPhase = ''
    unpackFile ${src}
    mv llvm-${version}.src llvm
    sourceRoot=$PWD/llvm
    unpackFile ${compiler-rt_src}
    mv compiler-rt-* $sourceRoot/projects/compiler-rt
  '';

  buildInputs = [ perl groff cmake libxml2 python libffi ] ++ stdenv.lib.optional stdenv.isLinux valgrind;

  propagatedBuildInputs = [ ncurses zlib ];

  prePatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'set(CMAKE_INSTALL_NAME_DIR "@rpath")' "set(CMAKE_INSTALL_NAME_DIR "$out/lib")" \
      --replace 'set(CMAKE_INSTALL_RPATH "@executable_path/../lib")' ""
  '';

  postPatch = stdenv.lib.optionalString (stdenv ? glibc) ''
    (
      cd projects/compiler-rt
      patch -p1 < ${
        fetchpatch {
          name = "sigaltstack.patch"; # for glibc-2.26
          url = https://github.com/llvm-mirror/compiler-rt/commit/8a5e425a68d.diff;
          sha256 = "0h4y5vl74qaa7dl54b1fcyqalvlpd8zban2d1jxfkxpzyi7m8ifi";
        }
      }

      sed -i "s,#include <pthread.h>,&\n#include <signal.h>,g" \
        lib/asan/asan_linux.cc
    )
  '';

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=${if debugVersion then "Debug" else "Release"}"
    "-DLLVM_BUILD_TESTS=ON"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_REQUIRES_RTTI=1"
  ] ++ stdenv.lib.optional enableSharedLibraries
    "-DBUILD_SHARED_LIBS=ON"
    ++ stdenv.lib.optional (!isDarwin)
    "-DLLVM_BINUTILS_INCDIR=${libbfd.dev}/include"
    ++ stdenv.lib.optionals ( isDarwin) [
    "-DCMAKE_CXX_FLAGS=-stdlib=libc++"
    "-DCAN_TARGET_i386=false"
  ];

  patches = [ ./fix-15974.patch ] ++
    stdenv.lib.optionals (!stdenv.isDarwin) [../fix-llvm-config.patch ];

  postBuild = ''
    rm -fR $out
  '';

  enableParallelBuilding = true;

  passthru.src = src;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.ncsa;
    maintainers = with stdenv.lib.maintainers; [ lovek323 raskin ];
    platforms = [ "i686-linux" "x86_64-linux" "x86_64-darwin" "armv7l-linux"];
  };
}

