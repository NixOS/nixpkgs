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
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "ROCR-Runtime";
    rev = "rocm-${version}";
    hash = "sha256-8hNb0Yo9ApedOG7xrUr5rwiA/YsqDTcyr6dBRg8lXro=";
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
