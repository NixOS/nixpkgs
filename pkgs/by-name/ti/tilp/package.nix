{
  libticonv,
  libtifiles2,
  libticables2,
  libticalcs2,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gtk2,
  intltool,
  pkg-config,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tilp";
  version = "1.18";
  src = fetchFromGitHub {
    owner = "debrouxl";
    repo = "tilp_and_gfm";
    rev = "9fb0fab9e91b5d5a43a1d907197734264b68fc6d";
    hash = "sha256-/XkxEfWzJiOkM5aoenp/GQSkkNg9qoXkFtcj/nenFEw=";
  };
  sourceRoot = finalAttrs.src.name + "/tilp/trunk/";
  nativeBuildInputs = [
    autoreconfHook
    intltool
    pkg-config
  ];
  buildInputs = [
    libticonv
    libtifiles2
    libticables2
    libticalcs2
    gtk2
  ];
  meta = {
    description = "TILP is a program allowing a computer to communicate with TI graphing calculators";
    homepage = "http://lpg.ticalc.org/prj_tilp";
    license = lib.licenses.gpl2Only;
    mainProgram = "tilp";
    maintainers = with lib.maintainers; [ clevor ];
    platforms = lib.platforms.unix;
  };
})
