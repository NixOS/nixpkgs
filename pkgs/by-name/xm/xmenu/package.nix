{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  libX11,
  libXft,
  libXinerama,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmenu";
  version = "4.6.1";

  src = fetchFromGitHub {
    owner = "phillbush";
    repo = "xmenu";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pCjL6cTH6hMzSV1L6wdMjfA2Dbf85KKCnBxmI9ibc7Y=";
  };

  buildInputs = [
    imlib2
    libX11
    libXft
    libXinerama
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "LOCALINC=${placeholder "out"}/include"
    "LOCALLIB=${placeholder "out"}/lib"
  ];

  meta = {
    description = "Menu utility for X";
    homepage = "https://github.com/phillbush/xmenu";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    mainProgram = "xmenu";
  };
})
