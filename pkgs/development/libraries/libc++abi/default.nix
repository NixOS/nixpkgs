{ stdenv, fetchsvn, libcxx, libunwind }:
let
  rev = "199626";
in stdenv.mkDerivation {
  name = "libcxxabi-pre-${rev}";

  src = fetchsvn {
    url = http://llvm.org/svn/llvm-project/libcxxabi/trunk;
    rev = "199626";
    sha256 = "0h1x1s40x5r65ar53rv34lmgcfil3zxaknqr64dka1mz29xhhrxy";
  };

  NIX_CFLAGS_LINK="-L${libunwind}/lib -lunwind";

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
    maintainers = stdenv.lib.maintainers.shlevy;
    platforms = stdenv.lib.platforms.linux;
  };
}
