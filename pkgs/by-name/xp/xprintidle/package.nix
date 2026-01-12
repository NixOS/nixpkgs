{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  libxscrnsaver,
  libxext,
  libx11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xprintidle";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "g0hl1n";
    repo = "xprintidle";
    rev = finalAttrs.version;
    sha256 = "sha256-MawkT4RconRDDCNnaWMxU18lK34ywcebbiHlYeZn/lc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libxscrnsaver
    libx11
    libxext
  ];

  meta = {
    homepage = "https://github.com/g0hl1n/xprintidle";
    description = "Utility that queries the X server for the user's idle time and prints it to stdout";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.linux;
    mainProgram = "xprintidle";
  };
})
