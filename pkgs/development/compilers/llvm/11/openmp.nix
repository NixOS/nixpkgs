{ lib
, stdenv
, fetch
, fetchpatch
, cmake
, llvm
, perl
, version
}:

stdenv.mkDerivation rec {
  pname = "openmp";
  inherit version;

  src = fetch pname "0bh5cswgpc79awlq8j5i7hp355adaac7s6zaz0zwp6mkflxli1yi";

  patches = [
    # Fix compilation on aarch64-darwin, remove after the next release.
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/7b5254223acbf2ef9cd278070c5a84ab278d7e5f.patch";
      sha256 = "sha256-A+9/IVIoazu68FK5H5CiXcOEYe1Hpp4xTx2mIw7m8Es=";
      stripLen = 1;
    })
  ];

  nativeBuildInputs = [ cmake perl ];
  buildInputs = [ llvm ];

  meta = {
    description = "Components required to build an executable OpenMP program";
    homepage    = "https://openmp.llvm.org/";
    license     = lib.licenses.mit;
    platforms   = lib.platforms.all;
  };
}
