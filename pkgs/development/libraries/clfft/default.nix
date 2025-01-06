{ lib, stdenv, fetchFromGitHub, cmake, fftw, fftwFloat, boost, opencl-clhpp, ocl-icd, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) OpenCL;
in
stdenv.mkDerivation rec {
  pname = "clfft";
  version = "2.12.2";

  src = fetchFromGitHub {
    owner = "clMathLibraries";
    repo = "clFFT";
    rev = "v${version}";
    hash = "sha256-yp7u6qhpPYQpBw3d+VLg0GgMyZONVII8BsBCEoRZm4w=";
  };

  sourceRoot = "${src.name}/src";

  postPatch = ''
    sed -i '/-m64/d;/-m32/d' CMakeLists.txt
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [ fftw fftwFloat boost ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ opencl-clhpp ocl-icd ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ OpenCL ];

  # https://github.com/clMathLibraries/clFFT/issues/237
  CXXFLAGS = "-std=c++98";

  meta = with lib; {
    description = "Library containing FFT functions written in OpenCL";
    longDescription = ''
      clFFT is a software library containing FFT functions written in OpenCL.
      In addition to GPU devices, the library also supports running on CPU devices to facilitate debugging and heterogeneous programming.
    '';
    license = licenses.asl20;
    homepage = "http://clmathlibraries.github.io/clFFT/";
    platforms = platforms.unix;
    maintainers = with maintainers; [ chessai ];
  };
}
