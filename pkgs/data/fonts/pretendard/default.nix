{ lib, stdenvNoCC, fetchzip }:

let
  version = "1.3.7";

  mkPretendard = { pname, typeface, hash }:
    stdenvNoCC.mkDerivation {
      inherit pname version;

      src = fetchzip {
        url = "https://github.com/orioncactus/pretendard/releases/download/v${version}/${typeface}-${version}.zip";
        stripRoot = false;
        inherit hash;
      };

      installPhase = ''
        runHook preInstall

        install -Dm644 public/static/*.otf -t $out/share/fonts/opentype

        runHook postInstall
      '';

      meta = with lib; {
        homepage = "https://github.com/orioncactus/pretendard";
        description = "An alternative font to system-ui for all platforms";
        license = licenses.ofl;
        platforms = platforms.all;
        maintainers = with maintainers; [ sudosubin ];
      };
    };

in
{
  pretendard = mkPretendard {
    pname = "pretendard";
    typeface = "Pretendard";
    hash = "sha256-p5yu0EcLp8dnj9aeQqAVL7jLD0eu/Er47D8NP8GqulY=";
  };

  pretendard-gov = mkPretendard {
    pname = "pretendard-gov";
    typeface = "PretendardGOV";
    hash = "sha256-gXI1S+zOKaM25OgMS0yYOrXuTxzLiIxp0dnB5lhtzyA=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    hash = "sha256-QM0Dd+Jh+K+uJB3nJXCkwoR8p/aNW5CpjlM81VR61Lc=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    hash = "sha256-UH4xgjf0blDX1djg0SC5sgpz3gTq1MsPoYOkYjJi+tI=";
  };
}
