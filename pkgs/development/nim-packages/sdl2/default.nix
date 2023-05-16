<<<<<<< HEAD
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
=======
{ lib, buildNimPackage, fetchNimble, SDL2 }:

buildNimPackage rec {
  pname = "sdl2";
  version = "2.0.4";
  src = fetchNimble {
    inherit pname version;
    hash = "sha256-Vtcj8goI4zZPQs2TbFoBFlcR5UqDtOldaXSH/+/xULk=";
  };
  propagatedBuildInputs = [ SDL2 ];
  doCheck = true;
  meta = {
    description = "Nim wrapper for SDL 2.x";
    platforms = lib.platforms.linux; # Problems with Darwin.
    license = [ lib.licenses.mit ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
