{ stdenv, lib, fetchFromGitHub, cmake,
  mesa, libGLU, glfw,
  libX11, libXi, libXcursor, libXrandr, libXinerama,
  alsaSupport ? stdenv.hostPlatform.isLinux, alsa-lib,
  pulseSupport ? stdenv.hostPlatform.isLinux, libpulseaudio,
  sharedLib ? true,
  includeEverything ? true
}:

stdenv.mkDerivation rec {
  pname = "raylib";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = pname;
    rev = version;
    sha256 = "1mszf5v7qy38cv1fisq6xd9smb765hylhkv1ms9y7shmdl2ni6b7";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mesa libGLU glfw libX11 libXi libXcursor libXrandr libXinerama
  ] ++ lib.optional alsaSupport alsa-lib
    ++ lib.optional pulseSupport libpulseaudio;

  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DBUILD_EXAMPLES=OFF"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON"
    ++ lib.optional sharedLib "-DBUILD_SHARED_LIBS=ON";

  # fix libasound.so/libpulse.so not being found
  preFixup = ''
    ${lib.optionalString alsaSupport "patchelf --add-needed ${alsa-lib}/lib/libasound.so $out/lib/libraylib.so.${version}"}
    ${lib.optionalString pulseSupport "patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libraylib.so.${version}"}
  '';

  meta = with lib; {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "https://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.linux;
    changelog = "https://github.com/raysan5/raylib/blob/${version}/CHANGELOG";
  };
}
