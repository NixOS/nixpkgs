{ stdenv, lib, fetchFromGitHub, fetchpatch, cmake,
  mesa, libGLU, glfw,
  libX11, libXi, libXcursor, libXrandr, libXinerama,
  alsaSupport ? stdenv.hostPlatform.isLinux, alsaLib,
  pulseSupport ? stdenv.hostPlatform.isLinux, libpulseaudio,
  includeEverything ? true
}:

stdenv.mkDerivation rec {
  pname = "raylib";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "raysan5";
    repo = pname;
    rev = version;
    sha256 = "0syvd5js1lbx3g4cddwwncqg95l6hb3fdz5nsh5pqy7fr6v84kwj";
  };

  patches = [
    # fixes examples not compiling in 3.5.0
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/raysan5/raylib/pull/1470.patch";
      sha256 = "1ff5l839wl8dxwrs2bwky7kqa8kk9qmsflg31sk5vbil68dzbzg0";
    })
  ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    mesa libGLU glfw libX11 libXi libXcursor libXrandr libXinerama
  ] ++ lib.optional alsaSupport alsaLib
    ++ lib.optional pulseSupport libpulseaudio;

  # https://github.com/raysan5/raylib/wiki/CMake-Build-Options
  cmakeFlags = [
    "-DUSE_EXTERNAL_GLFW=ON"
    "-DSHARED=ON"
    "-DBUILD_EXAMPLES=OFF"
  ] ++ lib.optional includeEverything "-DINCLUDE_EVERYTHING=ON";

  # fix libasound.so/libpulse.so not being found
  preFixup = ''
    ${lib.optionalString alsaSupport "patchelf --add-needed ${alsaLib}/lib/libasound.so $out/lib/libraylib.so.${version}"}
    ${lib.optionalString pulseSupport "patchelf --add-needed ${libpulseaudio}/lib/libpulse.so $out/lib/libraylib.so.${version}"}
  '';

  meta = with lib; {
    description = "A simple and easy-to-use library to enjoy videogames programming";
    homepage = "http://www.raylib.com/";
    license = licenses.zlib;
    maintainers = with maintainers; [ adamlwgriffiths ];
    platforms = platforms.linux;
  };
}
