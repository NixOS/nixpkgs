{
  lib,
  stdenv,
  go-md2man,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "yascreen";
  version = "2.06";

  src = fetchFromGitHub {
    owner = "bbonev";
    repo = "yascreen";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CIeWghtOnuQmEMwIpC1Xo1zLsuV4c0V7YAXTqUAzX1g=";
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
