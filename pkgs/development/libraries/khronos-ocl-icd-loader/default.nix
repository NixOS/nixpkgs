{ lib, stdenv, fetchFromGitHub, opencl-headers, cmake, withTracing ? false }:

stdenv.mkDerivation rec {
  pname = "khronos-ocl-icd-loader";
  version = "2023.12.14";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${version}";
    sha256 = "sha256-/4ixQAwJpygdg+qtR1ccBlz8hmtYYxRgUV5dlJabsg8=";
  };

  patches = lib.optional withTracing ./tracing.patch;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-headers ];

  meta = with lib; {
    description = "Official Khronos OpenCL ICD Loader";
    homepage = "https://github.com/KhronosGroup/OpenCL-ICD-Loader";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidtwco ];
  };
}
