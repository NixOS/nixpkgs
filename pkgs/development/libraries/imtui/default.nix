{ lib
, stdenv
, fetchFromGitHub
, cmake
, imgui
, ninja
, withEmscripten ? false, emscripten
, withCurl ? (!withEmscripten), curl
, withNcurses ? (!withEmscripten), ncurses
, static ? withEmscripten
}:

stdenv.mkDerivation rec {
  pname = "imtui";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "ggerganov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eHQPDEfxKGLdiOi0lUUgqJcmme1XJLSPAafT223YK+U=";
  };

  nativeBuildInputs = [ cmake ninja ];

  buildInputs = lib.optional withEmscripten emscripten
    ++ lib.optional withCurl curl
    ++ lib.optional withNcurses ncurses;

  postPatch = ''
    cp -r ${imgui}/include/imgui third-party/imgui
  '';

  cmakeFlags = [
    "-DEMSCRIPTEN:BOOL=${if withEmscripten then "ON" else "OFF"}"
    "-DIMTUI_SUPPORT_CURL:BOOL=${if withCurl then "ON" else "OFF"}"
    "-DIMTUI_SUPPORT_NCURSES:BOOL=${if withNcurses then "ON" else "OFF"}"
    "-DBUILD_SHARED_LIBS:BOOL=${if (!static) then "ON" else "OFF"}"
    "-DIMTUI_BUILD_EXAMPLES:BOOL=OFF"
    "-DIMTUI_INSTALL_IMGUI_HEADERS:BOOL=OFF"
  ];

  postInstall = ''
    rm -rf $out/include/imgui
  '';

  meta = with lib; {
    description = "Immediate mode text-based user interface library";
    longDescription = ''
      ImTui is an immediate mode text-based user interface library. Supports 256
      ANSI colors and mouse/keyboard input.
    '';
    homepage = "https://imtui.ggerganov.com";
    changelog = "https://github.com/ggerganov/imtui/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ azahi ];
  };
}
