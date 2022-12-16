{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-device-libs
, libxml2
}:

let
  llvmNativeTarget =
    if stdenv.isx86_64 then "X86"
    else if stdenv.isAarch64 then "AArch64"
    else throw "Unsupported ROCm LLVM platform";
in stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-comgr";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-CompilerSupport";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-qLsrBTeSop7lIQv8gZDwgpvGZJOAq90zsvMi1QpfbAs=";
  };

  patches = [ ./cmake.patch ];
  sourceRoot = "${finalAttrs.src.name}/lib/comgr";

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocm-device-libs
    libxml2
  ];

  cmakeFlags = [ "-DLLVM_TARGETS_TO_BUILD=AMDGPU;X86" ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "APIs for compiling and inspecting AMDGPU code objects";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/tree/amd-stg-open/lib/comgr";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    broken = finalAttrs.version != stdenv.cc.version;
  };
})
