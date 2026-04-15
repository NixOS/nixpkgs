{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
}:

stdenvNoCC.mkDerivation {
  pname = "xkcd-font";
  version = "0-unstable-2017-08-24";

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "xkcd-font";
    rev = "5632fde618845dba5c22f14adc7b52bf6c52d46d";
    hash = "sha256-1DgSx2L+OpXuPVSXbbl/hcZUyBK9ikPyGWuk6wNzlwc=";
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
}
