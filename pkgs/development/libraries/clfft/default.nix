{ lib, stdenv, fetchFromGitHub, cmake, fftw, fftwFloat, boost166, opencl-clhpp, ocl-icd }:

stdenv.mkDerivation rec {
  pname = "clfft";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "clMathLibraries";
    repo = "clFFT";
    rev = "refs/tags/v${version}";
    sha256 = "134vb6214hn00qy84m4djg4hqs6hw19gkp8d0wlq8gb9m3mfx7na";
  };

  sourceRoot = "source/src";

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw fftwFloat boost166 opencl-clhpp ocl-icd ];

  meta = with lib; {
    description = "Library containing FFT functions written in OpenCL";
    longDescription = ''
      clFFT is a software library containing FFT functions written in OpenCL.
      In addition to GPU devices, the library also supports running on CPU devices to facilitate debugging and heterogeneous programming.
    '';
    license = licenses.asl20;
    homepage = "http://clmathlibraries.github.io/clFFT/";
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ chessai ];
  };
}
