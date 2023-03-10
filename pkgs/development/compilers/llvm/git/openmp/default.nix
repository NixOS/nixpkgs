{ lib
, stdenv
, llvm_meta
, monorepoSrc
, runCommand
, cmake
, llvm
, lit
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
    ./fix-find-tool.patch
    ./gnu-install-dirs.patch
    ./run-lit-directly.patch
  ];

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ cmake perl pkg-config lit ];
  buildInputs = [ llvm ];

  # Unsup:Pass:XFail:Fail
  # 26:267:16:8
  doCheck = false;
  checkTarget = "check-openmp";

  preCheck = ''
    patchShebangs ../tools/archer/tests/deflake.bash
  '';

  cmakeFlags = [
    "-DCLANG_TOOL=${clang-unwrapped}/bin/clang"
    "-DOPT_TOOL=${llvm}/bin/opt"
    "-DLINK_TOOL=${llvm}/bin/llvm-link"
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
