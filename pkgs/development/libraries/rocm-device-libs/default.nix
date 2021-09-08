{ lib, stdenv
, fetchFromGitHub
, cmake
, clang
, clang-unwrapped
, lld
, llvm
}:

stdenv.mkDerivation rec {
  pname = "rocm-device-libs";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${version}";
    hash = "sha256-fPD9vevO2UDaFaclSI0CC/lRfM5WemWmxP1K5ajXHbk=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ clang lld llvm ];

  cmakeBuildType = "Release";

  cmakeFlags = [
    "-DCMAKE_PREFIX_PATH=${llvm}/lib/cmake/llvm;${clang-unwrapped}/lib/cmake/clang"
    "-DLLVM_TARGETS_TO_BUILD='AMDGPU;X86'"
    "-DCLANG=${clang}/bin/clang"
  ];

  meta = with lib; {
    description = "Set of AMD-specific device-side language runtime libraries";
    homepage = "https://github.com/RadeonOpenCompute/ROCm-Device-Libs";
    license = licenses.ncsa;
    maintainers = with maintainers; [ lovesegfault ];
    platforms = platforms.linux;
  };
}
