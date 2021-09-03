{ lib, stdenv, fetchFromGitHub, opencl-headers, cmake, withTracing ? false }:

stdenv.mkDerivation rec {
  name = "khronos-ocl-icd-loader-${version}";
  version = "2020.06.16";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${version}";
    sha256 = "0v2yi6d3g5qshzy6pjic09c5irwgds106yvr93q62f32psfblnmy";
  };

  patches = lib.optional withTracing ./tracing.patch;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-headers ];

  meta = with lib; {
    description = "Offical Khronos OpenCL ICD Loader";
    homepage = "https://github.com/KhronosGroup/OpenCL-ICD-Loader";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidtwco ];
  };
}
