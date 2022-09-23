{ lib, stdenv, fetchFromGitHub, opencl-headers, cmake, withTracing ? false }:

stdenv.mkDerivation rec {
  pname = "khronos-ocl-icd-loader";
  version = "2022.01.04";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${version}";
    sha256 = "sha256-T2tBoN0yv41W+UksFABVjsetdkXlnEFUINfxumGgC04=";
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
