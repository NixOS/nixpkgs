{ stdenv, fetchurl, libcxx, libunwind }:

let rev = "199626"; in

stdenv.mkDerivation {
  name = "libc++abi-${rev}";

  src = fetchurl {
    url = "http://tarballs.nixos.org/libcxxabi-${rev}.tar.bz2";
    sha256 = "09wr6qwgmdzbmgfkdzfhph9giy0zd6fp3s017fcfy4g0prjn5s4c";
  };

  NIX_CFLAGS_LINK = "-L${libunwind}/lib -lunwind";

  postUnpack = ''
    unpackFile ${libcxx.src}
    export NIX_CFLAGS_COMPILE="-I${libunwind}/include -I$PWD/include -I$(readlink -f libcxx-*)/include"
  '';

  installPhase = ''
    install -d -m 755 $out/include $out/lib
    install -m 644 lib/libc++abi.so.1.0 $out/lib
    install -m 644 include/cxxabi.h $out/include
    ln -s libc++abi.so.1.0 $out/lib/libc++abi.so
    ln -s libc++abi.so.1.0 $out/lib/libc++abi.so.1
  '';

  patchPhase = "sed -e s,-lstdc++,, -i lib/buildit";

  buildPhase = "(cd lib; ./buildit)";

  meta = {
    homepage = http://libcxxabi.llvm.org/;
    description = "A new implementation of low level support for a standard C++ library";
    license = "BSD";
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    platforms = stdenv.lib.platforms.linux;
  };
}
