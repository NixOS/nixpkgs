{ lib
, stdenv
, llvm_meta
, release_version
, patches ? []
, monorepoSrc ? null
, src ? null
, runCommand
, cmake
, ninja
, llvm
, targetLlvm
, lit
, clang-unwrapped
, perl
, pkg-config
, version
}:
let
  pname = "openmp";
  src' =
    if monorepoSrc != null then
      runCommand "${pname}-src-${version}" {} ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/${pname} "$out"
      '' else src;
in
stdenv.mkDerivation (rec {
  inherit pname version patches;

  src = src';

  sourceRoot =
    if lib.versionOlder release_version "13" then null
    else "${src.name}/${pname}";

  outputs = [ "out" ]
    ++ lib.optionals (lib.versionAtLeast release_version "14") [ "dev" ];

  patchFlags =
    if lib.versionOlder release_version "14" then [ "-p2" ]
    else null;

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals (lib.versionAtLeast release_version "15") [
    ninja
  ] ++ [ perl ] ++ lib.optionals (lib.versionAtLeast release_version "14") [
    pkg-config lit
  ];

  buildInputs = [
    (if stdenv.buildPlatform == stdenv.hostPlatform then llvm else targetLlvm)
  ];

  cmakeFlags = lib.optionals (lib.versions.major release_version == "13") [
    "-DLIBOMPTARGET_BUILD_AMDGCN_BCLIB=OFF" # Building the AMDGCN device RTL fails
  ] ++ lib.optionals (lib.versionAtLeast release_version "14") [
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
} // (lib.optionalAttrs (lib.versionAtLeast release_version "14") {
  doCheck = false;
  checkTarget = "check-openmp";
  preCheck = ''
    patchShebangs ../tools/archer/tests/deflake.bash
  '';
}))
