{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xjump-sdl";
  version = "3.0.5";

  src = fetchFromGitHub {
    owner = "hugomg";
    repo = "xjump-sdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a3d9d/Zif8UNUU+Tpgx8U34TpXMEHMg2KSpZR16mOOg=";
  };

  buildInputs = [ SDL2 ];

  meta = {
    description = "Jumping game for modern graphical systems";
    longDescription = ''
      Xjump is a jumping game where you are in a Falling Tower.
      The floor you are standing on is sinking with the rest of the building;
      you will die once the floor gives way (disappears under the bottom of the display).
      To survive, you have to jump onto the upper floors of the tower.
      Because the entire tower is sinking, the upper floors will soon collapse too,
      so you have to keep on jumping!

      This version of Xjump is a re-implementation using SDL instead of Xlib.
      It features smoother animations (60 FPS with smooth scrolling)
      and is more compatible with modern graphical systems.
    '';
    homepage = "https://github.com/hugomg/xjump-sdl";
    maintainers = with lib.maintainers; [ marcin-serwin ];
    mainProgram = "xjump";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
  };
})
