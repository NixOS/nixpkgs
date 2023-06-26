{ lib, buildNimPackage, fetchNimble, SDL2 }:

buildNimPackage (finalAttrs: {
  pname = "sdl2";
  version = "2.0.4";
  src = fetchNimble {
    inherit (finalAttrs) pname version;
    hash = "sha256-Vtcj8goI4zZPQs2TbFoBFlcR5UqDtOldaXSH/+/xULk=";
  };
  propagatedBuildInputs = [ SDL2 ];
  meta = {
    description = "Nim wrapper for SDL 2.x";
    platforms = lib.platforms.linux; # Problems with Darwin.
    license = [ lib.licenses.mit ];
  };
})
