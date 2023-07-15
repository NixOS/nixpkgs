{ stdenv, lib, fetchFromGitHub, cmake, fetchpatch
, mesa, libGLU, glfw
, libX11, libXi, libXcursor, libXrandr, libXinerama
, alsaSupport ? stdenv.hostPlatform.isLinux, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux, libpulseaudio
, sharedLib ? true
, includeEverything ? true
, raylib-games
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "raylib";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib";
    rev = finalAttrs.version;
    hash = "sha256-Uqqzq5shDp0AgSBT5waHBNUkEu0LRj70SNOlR5R2yAM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    mesa glfw libXi libXcursor libXrandr libXinerama
  ] ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;
  propagatedBuildInputs = [ libGLU libX11 ];

  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DCUSTOMIZE_BUILD=1"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON"
    ++ lib.optional sharedLib "-DBUILD_SHARED_LIBS=ON";

  passthru.tests = [ raylib-games ];

  meta = with lib; {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.linux;
    changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.version}/CHANGELOG";
  };
})
