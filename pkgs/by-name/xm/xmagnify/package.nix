{
  lib,
  stdenv,
  fetchFromGitLab,
  libx11,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xmagnify";
  version = "0.1.0";

  src = fetchFromGitLab {
    owner = "amiloradovsky";
    repo = "magnify";
    rev = finalAttrs.version;
    hash = "sha256-sMlAkD1qzd9Os6U6cwjQmVfjq7/StwV3GXvQX1y59tk=";
  };

  prePatch = ''
    substituteInPlace Makefile --replace-fail /usr $out
    # gcc15
    substituteInPlace main.c --replace-fail 'handler ()' 'handler (int sig)'
  '';

  buildInputs = [
    libx11
    xorgproto
  ];

  meta = {
    description = "Tiny screen magnifier for X11";
    homepage = "https://gitlab.com/amiloradovsky/magnify";
    license = lib.licenses.mit; # or GPL2+, optionally
    maintainers = [ ];
    mainProgram = "magnify";
    platforms = lib.platforms.all;
  };
})
