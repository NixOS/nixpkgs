{ stdenv
, fetchFromGitHub
, cmake
, clang
, clang-unwrapped
, lld
, llvm
, rocm-runtime
}:

stdenv.mkDerivation rec {
  pname = "rocm-device-libs";
  version = "3.5.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${version}";
    sha256 = "180bx05l293hrhzk2ymx41j5lhskysywvx33igbbsngzailwsc22";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang lld llvm rocm-runtime ];

  cmakeBuildType = "Release";

  cmakeFlags = [
    "-DCMAKE_PREFIX_PATH=${llvm}/lib/cmake/llvm;${clang-unwrapped}/lib/cmake/clang"
    "-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'"
    "-DCLANG=${clang}/bin/clang"
  ];

  meta = with stdenv.lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ danieldk ];
    platforms = platforms.linux;
  };
}
