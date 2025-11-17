{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libX11,
  perl,
  libXtst,
  xorgproto,
  libXi,
  libXinerama,
  libxkbcommon,
  libXext,
}:

stdenv.mkDerivation rec {
  pname = "xdotool";
  version = "3.20211022.1";

  src = fetchFromGitHub {
    owner = "jordansissel";
    repo = "xdotool";
    rev = "v${version}";
    sha256 = "sha256-XFiaiHHtUSNFw+xhUR29+2RUHOa+Eyj1HHfjCUjwd9k=";
  };

  nativeBuildInputs = [
    pkg-config
    perl
  ];
  buildInputs = [
    libX11
    libXtst
    xorgproto
    libXi
    libXinerama
    libxkbcommon
    libXext
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
}
