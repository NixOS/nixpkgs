{ stdenv, lib, fetchFromGitHub, cmake, fetchpatch
, mesa, libGLU, glfw
, libX11, libXi, libXcursor, libXrandr, libXinerama
, alsaSupport ? stdenv.hostPlatform.isLinux, alsa-lib
, pulseSupport ? stdenv.hostPlatform.isLinux, libpulseaudio
, sharedLib ? true
, includeEverything ? true
, raylib-games
}:

stdenv.mkDerivation rec {
  pname = "raylib";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = pname;
    rev = version;
    sha256 = "sha256-aMIjywcQxki0cKlNznPAMfvrtGj3qcR95D4/BDuPZZM=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    mesa glfw libXi libXcursor libXrandr libXinerama
  ] ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;
  propagatedBuildInputs = [ libGLU libX11 ];

  patches = [
    # fixes glfw compile error;
    # remove with next raylib version > 4.2.0 or when glfw 3.4.0 is released.
    (fetchpatch {
      url = "https://github.com/raysan5/raylib/commit/2ad7967db80644a25ca123536cf2f6efcb869684.patch";
      sha256 = "sha256-/xgzox1ITeoZ91QWdwnJJ+jJ5nJsMHcEgbIEdNYh4NY=";
      name = "raylib-glfw-fix.patch";
    })
  ];

  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
    "-DCUSTOMIZE_BUILD=1"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON"
    ++ lib.optional sharedLib "-DBUILD_SHARED_LIBS=ON";

  # fix libasound.so/libpulse.so not being found
  preFixup = ''
    ${lib.optionalString alsaSupport "patchelf --add-needed ${alsa-lib}/lib/libasound.so $out/lib/libraylib.so.${version}"}
    ${lib.optionalString pulseSupport "patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libraylib.so.${version}"}
  '';

  passthru.tests = [ raylib-games ];

  meta = with lib; {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.linux;
    changelog = "https://github.com/raysan5/raylib/blob/${version}/CHANGELOG";
  };
}
