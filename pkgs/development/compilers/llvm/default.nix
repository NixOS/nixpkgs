{ stdenv, fetchurl, perl, groff, cmake, python, libffi }:

let version = "3.3"; in

stdenv.mkDerivation {
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

  # created binaries need to be run before installation... I coudn't find a better way
  preBuild = ''export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:"`pwd`/lib'';

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=Release" "-DBUILD_SHARED_LIBS=ON" "-DLLVM_ENABLE_FFI=ON" ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = http://llvm.org/;
    description = "Collection of modular and reusable compiler and toolchain technologies";
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric shlevy raskin];
    platforms = with stdenv.lib.platforms; all;
  };
}
