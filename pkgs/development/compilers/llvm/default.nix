{ stdenv, fetchurl, perl, groff, cmake, python, libffi, binutils_gold }:

let version = "3.3"; in

stdenv.mkDerivation rec {
  name = "llvm-${version}";

  src = fetchurl {
    url    = "http://llvm.org/releases/${version}/llvm-${version}.src.tar.gz";
    sha256 = "0y3mfbb5qzcpw3v5qncn69x1hdrrrfirgs82ypi2annhf0g6nxk8";
  };

  # The default rlimits are too low for shared libraries.
  patches = [ ./more-memory-for-bugpoint.patch ];

  # libffi was propagated before, but it wasn't even being used, so
  # unless something needs it just an input is fine.
  buildInputs = [ perl groff cmake python libffi ]; # ToDo: polly, libc++; enable cxx11?

  # hacky fix: created binaries need to be run before installation
  preBuild = let LD = if stdenv.isDarwin then "DYLD" else "LD";
    in "export ${LD}_LIBRARY_PATH='$$${LD}_LIBRARY_PATH:'`pwd`/lib";

  cmakeFlags = with stdenv; [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DLLVM_ENABLE_FFI=ON"
    "-DLLVM_BINUTILS_INCDIR=${binutils_gold}/include"
    "-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=R600" # for mesa
  ] ++ lib.optional (!isDarwin) "-DBUILD_SHARED_LIBS=ON";

  enableParallelBuilding = true;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Collection of modular and reusable compiler and toolchain technologies";
    homepage    = http://llvm.org/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ lovek323 raskin shlevy viric ];
    platforms   = platforms.all;
  };
}
