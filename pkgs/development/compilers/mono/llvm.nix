{ stdenv
, fetchurl
, perl
, groff
, cmake
, python
, libffi
, binutils
, libxml2
, valgrind
, ncurses
, zlib
}:

stdenv.mkDerivation rec {
  name    = "llvm-${version}";
  version = "3.4svn-mono-f9b1a74368";
  src = fetchurl {
    # from the HEAD of the 'mono3' branch
    url = "https://github.com/mono/llvm/archive/f9b1a74368ec299fc04c4cfef4b5aa0992b7b806.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1bbkx4p5zdnk3nbdd5jxvbwqx8cdq8z1n1nhf639i98mggs0zhdg";
  };

  patches = [ ./build-fix-llvm.patch ];
  unpackPhase = ''
    unpackFile ${src}
    mv llvm-* llvm
    sourceRoot=$PWD/llvm
  '';

  buildInputs = [ perl groff cmake libxml2 python libffi ] ++ stdenv.lib.optional stdenv.isLinux valgrind;

  propagatedBuildInputs = [ ncurses zlib ];

  # hacky fix: created binaries need to be run before installation
  preBuild = ''
    mkdir -p $out/
    ln -sv $PWD/lib $out
  '';
  postBuild = "rm -fR $out";

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_BINUTILS_INCDIR=${binutils.dev}/include"
    "-DCMAKE_CXX_FLAGS=-std=c++11"
  ] ++ stdenv.lib.optional (!isDarwin) "-DBUILD_SHARED_LIBS=ON";

  enableParallelBuilding = true;

  meta = {
    description = "Collection of modular and reusable compiler and toolchain technologies - Mono build";
    homepage    = http://llvm.org/;
    license     = stdenv.lib.licenses.bsd3;
    maintainers = with stdenv.lib.maintainers; [ thoughtpolice ];
    platforms   = stdenv.lib.platforms.all;
  };
}
