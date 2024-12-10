{
  lib,
  stdenv,
  fetchFromGitHub,
  opencl-headers,
  cmake,
  withTracing ? false,
}:

stdenv.mkDerivation rec {
  pname = "opencl-icd-loader";
  version = "2023.12.14";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${version}";
    hash = "sha256-/4ixQAwJpygdg+qtR1ccBlz8hmtYYxRgUV5dlJabsg8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-headers ];

  cmakeFlags = [
    (lib.cmakeBool "OCL_ICD_ENABLE_TRACE" withTracing)
  ];

  meta = with lib; {
    description = "Official Khronos OpenCL ICD Loader";
    mainProgram = "cllayerinfo";
    homepage = "https://github.com/KhronosGroup/OpenCL-ICD-Loader";
    license = licenses.asl20;
    maintainers = with maintainers; [ davidtwco ];
    platforms = platforms.unix;
  };
}
