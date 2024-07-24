{ lib, stdenvNoCC, fetchzip }:

stdenvNoCC.mkDerivation rec {
  pname = "hackgen-nf-font";
  version = "2.9.0";

  src = fetchzip {
    url = "https://github.com/yuru7/HackGen/releases/download/v${version}/HackGen_NF_v${version}.zip";
    hash = "sha256-Lh4WQJjeP4JuR8jSXpRNSrjRsNPmNXSx5AItNYMJL2A=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/hackgen-nf

    runHook postInstall
  '';

  meta = with lib; {
    description = "Composite font of Hack, GenJyuu-Gothic and nerd-fonts";
    homepage = "https://github.com/yuru7/HackGen";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ natsukium ];
  };
}
