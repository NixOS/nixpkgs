{ lib, stdenvNoCC, fetchzip }:

let
  version = "1.3.4";

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
    hash = "sha256-rkjT0zuNDBu/TF21o8DH1K9AqimTRvYkntmqwqVdgXQ=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    hash = "sha256-u9XT6Xyn6B+TNRd7Pg8z4QEh6gkG1t4084sxkZioaIc=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    hash = "sha256-JgaCRXMntf/EJDS8Mm+xJemW4fcrOXnAPgEtvi7/Qok=";
  };
}
