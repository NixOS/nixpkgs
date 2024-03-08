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

  src = fetch pname "14dh0r6h2xh747ffgnsl4z08h0ri04azi9vf79cbz7ma1r27kzk0";

  patches = [
    # Fix cross.
    (fetchpatch {
      url = "https://github.com/llvm/llvm-project/commit/5e2358c781b85a18d1463fd924d2741d4ae5e42e.patch";
      hash = "sha256-UxIlAifXnexF/MaraPW0Ut6q+sf3e7y1fMdEv1q103A=";
    })
  ];

  patchFlags = [ "-p2" ];

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
