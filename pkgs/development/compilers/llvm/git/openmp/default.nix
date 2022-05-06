{ lib
, stdenv
, llvm_meta
, monorepoSrc
, runCommand
, cmake
, llvm
, clang-unwrapped
, perl
, pkg-config
, version
}:

stdenv.mkDerivation rec {
  pname = "openmp";
  inherit version;

  src = runCommand "${pname}-src-${version}" {} ''
    mkdir -p "$out"
    cp -r ${monorepoSrc}/cmake "$out"
    cp -r ${monorepoSrc}/${pname} "$out"
  '';

  sourceRoot = "${src.name}/${pname}";

  patches = [
    ./gnu-install-dirs.patch
    ./fix-find-tool.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake perl pkg-config clang-unwrapped ];
  buildInputs = [ llvm ];

  cmakeFlags = [
    "-DLIBOMPTARGET_BUILD_AMDGCN_BCLIB=OFF" # Building the AMDGCN device RTL currently fails
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
