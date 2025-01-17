{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hackgen-font";
  version = "2.9.1";

  src = fetchzip {
    url = "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_v${version}.zip";
    hash = "sha256-PkCaidfPcUBGjPu36Jza175jCu6WJ06YhVFDENzd+Z4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/hackgen

    runHook postInstall
  '';

  meta = with lib; {
    description = "Composite font of Hack and GenJyuu-Goghic";
    homepage = "https://github.com/yuru7/HackGen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ natsukium ];
  };
}
