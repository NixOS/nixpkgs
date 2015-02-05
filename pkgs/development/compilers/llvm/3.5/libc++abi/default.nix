{ stdenv, cmake, coreutils, fetchurl, libcxx, libunwind, llvm }:

let version = "3.5.0"; in

stdenv.mkDerivation {
  name = "libc++abi-${version}";

  src = fetchurl {
    url = "http://llvm.org/releases/${version}/libcxxabi-${version}.src.tar.xz";
    sha256 = "1ndcpw3gfrzh7m1jac2qadhkrqgvb65cns69j9niydyj5mmbxijk";
  };

  NIX_CFLAGS_LINK = "-L${libunwind}/lib";

  buildInputs = [ coreutils cmake llvm ];

  postUnpack = ''
    unpackFile ${libcxx.src}
    export NIX_CFLAGS_COMPILE+=" -I${libunwind}/include -I$PWD/include"
    export cmakeFlags="-DLIBCXXABI_LIBCXX_INCLUDES=$(${coreutils}/bin/readlink -f libcxx-*)/include"
  '' + stdenv.lib.optionalString stdenv.isDarwin ''
    export TRIPLE=x86_64-apple-darwin
  '';

  installPhase = if stdenv.isDarwin
    then ''
      for file in lib/*; do
        # this should be done in CMake, but having trouble figuring out
        # the magic combination of necessary CMake variables
        # if you fancy a try, take a look at
        # http://www.cmake.org/Wiki/CMake_RPATH_handling
        install_name_tool -id $out/$file $file
      done
      make install
      install -d 755 $out/include
      install -m 644 ../include/cxxabi.h $out/include
    ''
    else ''
      install -d -m 755 $out/include $out/lib
      install -m 644 lib/libc++abi.so.1.0 $out/lib
      install -m 644 ../include/cxxabi.h $out/include
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
      ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
    '';

  meta = {
    homepage = http://libcxxabi.llvm.org/;
    description = "A new implementation of low level support for a standard C++ library";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [ shlevy vlstill ];
    platforms = stdenv.lib.platforms.unix;
  };
}
