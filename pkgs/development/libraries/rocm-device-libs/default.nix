{ stdenv
, fetchFromGitHub
, cmake
, clang
, clang-unwrapped
, lld
, llvm
}:

stdenv.mkDerivation rec {
  pname = "rocm-device-libs";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${version}";
    sha256 = "1sg7wzj2mi5vhba53cp52gnya7c799f0p325ig262vi70r7mr7n2";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang lld llvm ];

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
