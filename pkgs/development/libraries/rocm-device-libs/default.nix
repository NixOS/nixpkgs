{ lib, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, clang
, llvm
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rocm-device-libs";
  version = "5.4.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-8gxvgy2GlROxM5qKtZVu5Lxa1FmTIVlBTpfp8rxhNhk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang llvm ];

  cmakeFlags = [
    "-DCMAKE_PREFIX_PATH=${llvm}/lib/cmake/llvm;${llvm}/lib/cmake/clang"
    "-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'"
    "-DCLANG=${clang}/bin/clang"
  ];

  patches = [ ./cmake.patch ];

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
  };
})
