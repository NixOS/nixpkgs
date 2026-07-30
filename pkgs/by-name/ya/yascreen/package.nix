{
  lib,
  stdenv,
  go-md2man,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yascreen";
  version = "2.13";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "yascreen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-641H0uR2rR9vVe7WF2bSzFs+6HXlPHWgD0jKH9MofqU=";
  };

  nativeBuildInputs = [ go-md2man ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = {
    homepage = "https://github.com/bbonev/yascreen";
    changelog = "https://github.com/bbonev/yascreen/releases/tag/${finalAttrs.src.tag}";
    description = "Curses replacement for daemons and embedded apps";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.arezvov ];
    platforms = lib.platforms.linux;
  };
})
