{ lib, buildNimPackage, fetchFromGitHub, SDL2 }:

buildNimPackage (final: prev: {
  pname = "sdl2";
  version = "2.0.5";
  src = fetchFromGitHub {
    owner = "nim-lang";
    repo = "sdl2";
    rev = "v${final.version}";
    hash = "sha256-oUTUWuBphoR0pBMkcJBVDW+dnnF8KK23F7eW3lOLNO4=";
  };
  propagatedBuildInputs = [ SDL2 ];
  meta = final.src.meta // {
    description = "Nim wrapper for SDL 2.x";
    homepage = "https://github.com/nim-lang/sdl2";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ ehmry ];
    badPlatforms = lib.platforms.darwin;
  };
})
