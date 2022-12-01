{ lib
, stdenv
, llvm_meta
, fetch
, cmake
, llvm
, targetLlvm
, perl
, version
}:

stdenv.mkDerivation {
  pname = "openmp";
  inherit version;

  src = fetch "openmp" "0p2n52676wlq6y9q99n5pivq6pvvda1p994r69fxj206ahn59jir";

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
