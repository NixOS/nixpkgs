{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  SDL2,
  libGLU,
}:

stdenv.mkDerivation {
  pname = "SDL_gpu-unstable";
  version = "2019-01-24";

  src = fetchFromGitHub {
    owner = "grimfang4";
    repo = "sdl-gpu";
    rev = "e3d350b325a0e0d0b3007f69ede62313df46c6ef";
    sha256 = "0kibcaim01inb6xxn4mr6affn4hm50vz9kahb5k9iz8dmdsrhxy1";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    libGLU
  ];

  cmakeFlags = [
    "-DSDL_gpu_BUILD_DEMOS=OFF"
    "-DSDL_gpu_BUILD_TOOLS=OFF"
    "-DSDL_gpu_BUILD_VIDEO_TEST=OFF"
    "-DSDL_gpu_BUILD_TESTS=OFF"
  ];

  patchPhase = ''
    sed -ie '210s#''${OUTPUT_DIR}/lib#''${CMAKE_INSTALL_LIBDIR}#' src/CMakeLists.txt
    sed -ie '213s#''${OUTPUT_DIR}/lib#''${CMAKE_INSTALL_LIBDIR}#' src/CMakeLists.txt
  '';

  meta = with lib; {
    description = "A library for high-performance, modern 2D graphics with SDL written in C";
    homepage = "https://github.com/grimfang4/sdl-gpu";
    license = licenses.mit;
    maintainers = with maintainers; [ pmiddend ];
    platforms = platforms.linux;
  };
}
