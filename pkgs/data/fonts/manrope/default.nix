{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "manrope";
  version = "4.505";

  src = fetchFromGitHub {
    owner = "sharanda";
    repo = pname;
    rev = "d79b66b10608610692d59f4107791d249d244416"; # no tags in repo
    hash = "sha256-dxnCOkPUEG0knSekolx2+SGJR81vRK0wUrbzGH4KGD0=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 fonts/otf/*.otf -t $out/share/fonts/opentype
    install -Dm644 fonts/ttf/*.ttf fonts/variable/*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    description = "Open-source modern sans-serif font family";
    homepage = "https://www.gent.media/manrope";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
