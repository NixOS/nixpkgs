{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libx11,
  perl,
  libxtst,
  xorgproto,
  libxi,
  libxinerama,
  libxkbcommon,
  libxext,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdotool";
  version = "3.20211022.1";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = "xdotool";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-XFiaiHHtUSNFw+xhUR29+2RUHOa+Eyj1HHfjCUjwd9k=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];
  buildInputs = [
    libx11
    libxtst
    xorgproto
    libxi
    libxinerama
    libxkbcommon
    libxext
  ];

  preBuild = ''
    mkdir -p $out/lib
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://www.semicomplete.com/projects/xdotool/";
    description = "Fake keyboard/mouse input, window management, and more";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    platforms = with lib.platforms; linux;
    mainProgram = "xdotool";
  };
})
