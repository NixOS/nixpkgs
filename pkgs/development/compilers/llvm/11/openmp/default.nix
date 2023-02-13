{ lib
, stdenv
, llvm_meta
, fetch
, fetchpatch
, cmake
, llvm
, targetLlvm
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
  buildInputs = [
    (if stdenv.buildPlatform == stdenv.hostPlatform then llvm else targetLlvm)
  ];

  meta = llvm_meta // {
    homepage = "https://openmp.llvm.org/";
    description = "Support for the OpenMP language";
    longDescription = ''
      The OpenMP subproject of LLVM contains the components required to build an
      executable OpenMP program that are outside the compiler itself.
      Contains the code for the runtime library against which code compiled by
      "clang -fopenmp" must be linked before it can run and the library that
      supports offload to target devices.
    '';
    # "All of the code is dual licensed under the MIT license and the UIUC
    # License (a BSD-like license)":
    license = with lib.licenses; [ mit ncsa ];
  };
}
