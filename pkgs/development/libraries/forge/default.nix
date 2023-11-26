{ boost
, cmake
, expat
, fetchFromGitHub
, fontconfig
, freeimage
, freetype
, glfw3
, glm
, lib
, libGLU
, libGL
, mesa
, opencl-clhpp
, pkg-config
, stdenv
, SDL2
}:

stdenv.mkDerivation rec {
  pname = "forge";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "arrayfire";
    repo = pname;
    rev = "v1.0.8";
    sha256 = "sha256-lSZAwcqAHiuZkpYcVfwvZCfNmEF3xGN9S/HuZQrGeKU=";
  };
  glad = fetchFromGitHub {
    owner = "arrayfire";
    repo = "glad";
    rev = "b94680aee5b8ce01ae1644c5f2661769366c765a";
    hash = "sha256-CrZy76gOGMpy9f1NuMK4tokZ57U//zYeNH5ZYY0SC2U=";
  };

  # This patch ensures that Forge does not try to fetch glad from GitHub and
  # uses our sources that we've checked out via Nix.
  patches = [ ./no-download-glad.patch ];

  postPatch = ''
    mkdir -p ./extern
    cp -R --no-preserve=mode,ownership ${glad} ./extern/fg_glad-src
    ln -s ${opencl-clhpp} ./extern/cl2hpp
  '';

  cmakeFlags = [ "-DFETCHCONTENT_FULLY_DISCONNECTED=ON" ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost.out
    boost.dev
    expat
    fontconfig
    freeimage
    freetype
    glfw3
    glm
    libGL
    libGLU
    opencl-clhpp
    SDL2
    mesa
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
    maintainers = with maintainers; [ chessai twesterhout ];
  };
}
