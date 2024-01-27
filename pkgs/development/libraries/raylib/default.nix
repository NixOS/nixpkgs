{ stdenv
, lib
, fetchFromGitHub
, cmake
, fetchpatch
, mesa
, libGLU
, glfw
, libX11
, libXi
, libXcursor
, libXrandr
, libXinerama
, alsaSupport ? stdenv.hostPlatform.isLinux
, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux
, libpulseaudio
, sharedLib ? true
, includeEverything ? true
, raylib-games
, darwin
}:
let
  inherit (darwin.apple_sdk.frameworks) Carbon Cocoa OpenGL;
in
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

  buildInputs = [ glfw ]
    ++ lib.optionals stdenv.isLinux [ mesa libXi libXcursor libXrandr libXinerama ]
    ++ lib.optionals stdenv.isDarwin [ Carbon Cocoa ]
    ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;

  propagatedBuildInputs = lib.optionals stdenv.isLinux [ libGLU libX11 ]
    ++ lib.optionals stdenv.isDarwin [ OpenGL ];

  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DCUSTOMIZE_BUILD=1"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON"
  ++ lib.optional sharedLib "-DBUILD_SHARED_LIBS=ON";

  passthru.tests = [ raylib-games ];

  patches = [
    # Patch version in CMakeList to 4.5.0
    # Remove this when updating to a new revision
    (fetchpatch {
      url = "https://github.com/raysan5/raylib/commit/0d4db7ad7f6fd442ed165ebf8ab8b3f4033b04e7.patch";
      hash = "sha256-RGokbQAwJAZm2FU2VNwraE3xko8E+RLLFjUfDRXeKhA=";
    })
  ];

  # fix libasound.so/libpulse.so not being found
  preFixup = ''
    ${lib.optionalString alsaSupport "patchelf --add-needed ${alsa-lib}/lib/libasound.so $out/lib/libraylib.so.${finalAttrs.version}"}
    ${lib.optionalString pulseSupport "patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libraylib.so.${finalAttrs.version}"}
  '';

  meta = with lib; {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.all;
    changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.version}/CHANGELOG";
  };
})
