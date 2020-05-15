{ stdenv, fetchFromGitHub, opencl-headers, cmake, withTracing ? false }:

stdenv.mkDerivation rec {
  name = "khronos-ocl-icd-loader-${version}";
  version = "2020.03.13";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v${version}";
    sha256 = "0zk6fyfrklx8a848613rfcx0y4yn0dsxkxzzl9pgdh9i6qdfjj9k";
  };

  patches = stdenv.lib.lists.optional withTracing ./tracing.patch;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-headers ];

  meta = with stdenv.lib; {
    description = "Offical Khronos OpenCL ICD Loader";
    homepage = "https://github.com/KhronosGroup/OpenCL-ICD-Loader";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidtwco ];
  };
}
