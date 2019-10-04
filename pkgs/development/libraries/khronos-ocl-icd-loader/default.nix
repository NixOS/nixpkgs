{ stdenv, fetchFromGitHub, opencl-clhpp, cmake, withTracing ? false }:

stdenv.mkDerivation rec {
  name = "khronos-ocl-icd-loader-${version}";
  version = "6c03f8b";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "6c03f8b58fafd9dd693eaac826749a5cfad515f8";
    sha256 = "00icrlc00dpc87prbd2j1350igi9pbgkz27hc3rf73s5994yn86a";
  };

  patches = stdenv.lib.lists.optional withTracing ./tracing.patch;

  nativeBuildInputs = [ cmake ];
  buildInputs = [ opencl-clhpp ];

  meta = with stdenv.lib; {
    description = "Offical Khronos OpenCL ICD Loader";
    homepage = https://github.com/KhronosGroup/OpenCL-ICD-Loader;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ davidtwco ];
  };
}
