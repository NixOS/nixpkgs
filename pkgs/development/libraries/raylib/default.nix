{ stdenv, lib, fetchFromGitHub, cmake, fetchpatch
, mesa, libGLU, glfw
, libX11, libXi, libXcursor, libXrandr, libXinerama
, alsaSupport ? stdenv.hostPlatform.isLinux, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux, libpulseaudio
, sharedLib ? true
, includeEverything ? true
, raylib-games
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "raylib";
  version = "4.5.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = "raylib";
    rev = finalAttrs.version;
    hash = "sha256-Uqqzq5shDp0AgSBT5waHBNUkEu0LRj70SNOlR5R2yAM=";
=======
stdenv.mkDerivation rec {
  pname = "raylib";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = pname;
    rev = version;
    sha256 = "sha256-aMIjywcQxki0cKlNznPAMfvrtGj3qcR95D4/BDuPZZM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    mesa glfw libXi libXcursor libXrandr libXinerama
  ] ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;
  propagatedBuildInputs = [ libGLU libX11 ];

<<<<<<< HEAD
=======
  patches = [
    # fixes glfw compile error;
    # remove with next raylib version > 4.2.0 or when glfw 3.4.0 is released.
    (fetchpatch {
      url = "https://github.com/raysan5/raylib/commit/2ad7967db80644a25ca123536cf2f6efcb869684.patch";
      sha256 = "sha256-/xgzox1ITeoZ91QWdwnJJ+jJ5nJsMHcEgbIEdNYh4NY=";
      name = "raylib-glfw-fix.patch";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DCUSTOMIZE_BUILD=1"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON"
    ++ lib.optional sharedLib "-DBUILD_SHARED_LIBS=ON";

<<<<<<< HEAD
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

=======
  # fix libasound.so/libpulse.so not being found
  preFixup = ''
    ${lib.optionalString alsaSupport "patchelf --add-needed ${alsa-lib}/lib/libasound.so $out/lib/libraylib.so.${version}"}
    ${lib.optionalString pulseSupport "patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libraylib.so.${version}"}
  '';

  passthru.tests = [ raylib-games ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.linux;
<<<<<<< HEAD
    changelog = "https://github.com/raysan5/raylib/blob/${finalAttrs.version}/CHANGELOG";
  };
})
=======
    changelog = "https://github.com/raysan5/raylib/blob/${version}/CHANGELOG";
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
