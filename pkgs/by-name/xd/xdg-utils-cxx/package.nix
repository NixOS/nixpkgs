{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-utils-cxx";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "azubieta";
    repo = "xdg-utils-cxx";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hEN0xqZUNfMOIrw3q+x4kEFhYoqmyn7W3f2w8AGw2wI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  # Fix the build with CMake 4.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'cmake_minimum_required(VERSION 3.0)' \
        'cmake_minimum_required(VERSION 3.10)'
  '';

  meta = {
    description = "Implementation of the FreeDesktop specifications to be used in c++ projects";
    homepage = "https://github.com/azubieta/xdg-utils-cxx";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "xdg-utils-cxx";
    platforms = lib.platforms.linux;
  };
})
