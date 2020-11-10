{ stdenv
, fetchFromGitHub
, addOpenGLRunpath
, clang-unwrapped
, cmake
, xxd
, elfutils
, llvm
, rocm-device-libs
, rocm-thunk }:

stdenv.mkDerivation rec {
  pname = "rocm-runtime";
  version = "3.9.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCR-Runtime";
    rev = "rocm-${version}";
    sha256 = "034qbqznfligg4lwd95zmqa7lwcda720zbfv066nqvarlcml0kr6";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ cmake xxd ];

  buildInputs = [ clang-unwrapped elfutils llvm ];

  cmakeFlags = [
   "-DBITCODE_DIR=${rocm-device-libs}/amdgcn/bitcode"
   "-DCMAKE_PREFIX_PATH=${rocm-thunk}"
  ];

  postPatch = ''
    patchShebangs image/blit_src/create_hsaco_ascii_file.sh
  '';

  fixupPhase = ''
    rm -rf $out/hsa
  '';

  meta = with stdenv.lib; {
    description = "Platform runtime for ROCm";
    homepage = "https://github.com/RadeonOpenCompute/ROCR-Runtime";
    license = with licenses; [ ncsa ];
    maintainers = with maintainers; [ danieldk ];
  };
}
