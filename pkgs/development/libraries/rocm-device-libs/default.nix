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
  version = "3.8.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCm-Device-Libs";
    rev = "rocm-${version}";
    sha256 = "0kgsp22rbg09q09n36j1vfs9v8x0liap3ycnqyn1g7dxy38kqmi4";
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
