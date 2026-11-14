{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation {
  pname = "vimv";
  version = "0-unstable-2019-10-31";

  src = fetchFromGitHub {
    owner = "thameera";
    repo = "vimv";
    rev = "4152496c1946f68a13c648fb7e583ef23dac4eb8";
    hash = "sha256-TX7HoMPXbjyJi8qYqC+minQRRZTs3TP56XgZ/UR3Wbs=";
  };

  installPhase = ''
    install -d $out/bin
    install $src/vimv $out/bin/vimv
    patchShebangs $out/bin/vimv
  '';

  meta = {
    homepage = "https://github.com/thameera/vimv";
    description = "Batch-rename files using Vim";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kmein ];
    mainProgram = "vimv";
  };
}
