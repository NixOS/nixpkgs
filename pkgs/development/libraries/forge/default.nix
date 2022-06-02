{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, arrayfire, expat, fontconfig, freeimage, freetype, boost
, mesa, libGLU, libGL, glfw3, SDL2, cudatoolkit
}:

stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "arrayfire";
    repo = "forge";
    rev = "v${version}";
    sha256 = "00pmky6kccd7pwi8sma79qpmzr2f9pbn6gym3gyqm64yckw6m484";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    expat
    fontconfig
    freetype
    boost.out
    boost.dev
    freeimage
    mesa
    libGLU libGL
    glfw3
    SDL2
    cudatoolkit
    arrayfire
  ];

  meta = with lib; {
    description = "An OpenGL interop library that can be used with ArrayFire or any other application using CUDA or OpenCL compute backend";
    longDescription = ''
      An OpenGL interop library that can be used with ArrayFire or any other application using CUDA or OpenCL compute backend.
      The goal of Forge is to provide high performance OpenGL visualizations for C/C++ applications that use CUDA/OpenCL.
      Forge uses OpenGL >=3.3 forward compatible contexts, so please make sure you have capable hardware before trying it out.
    '';
    license = licenses.bsd3;
    homepage = "https://arrayfire.com/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ chessai ];
  };

}
