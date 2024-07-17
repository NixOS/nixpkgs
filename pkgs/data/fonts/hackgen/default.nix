{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation rec {
  pname = "hackgen-font";
  version = "2.9.0";

  src = fetchzip {
    url = "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_v${version}.zip";
    hash = "sha256-Ah2oVP8nzFiYA76kMPa9+YHQwFxq4i1muwkcmC7TzOk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/hackgen

    runHook postInstall
  '';

  meta = with lib; {
    description = "A composite font of Hack and GenJyuu-Goghic";
    homepage = "https://github.com/yuru7/HackGen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ natsukium ];
  };
}
