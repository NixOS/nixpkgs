{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "xkcd-font";
  version = "2026.2";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "xkcd-font";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IRDwdrlktO/uda3etrv5fpsF6gd+AFAXmRz/X7U5CeA=";
  };

  preInstall = "rm xkcd/build/xkcd.otf";

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];

  meta = {
    description = "Xkcd font";
    homepage = "https://github.com/ipython/xkcd-font";
    license = lib.licenses.cc-by-nc-30;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pancaek ];
  };
})
