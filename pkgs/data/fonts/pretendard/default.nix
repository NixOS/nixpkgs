{ lib, stdenvNoCC, fetchzip }:

let
  version = "1.3.8";

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
    hash = "sha256-Re4Td9uA8Qn/xv39Bo9i3gShYWQ1mRX44Vyx7/i4xwI=";
  };

  pretendard-gov = mkPretendard {
    pname = "pretendard-gov";
    typeface = "PretendardGOV";
    hash = "sha256-GQv/Ia91QgXZwFX+WdE7aRFUJFWhCMLFY86gu4Ii2w8=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    hash = "sha256-7OLInF1XUQxyHyb9a0zyfCLZrdcxMTM2QeBe3lwLJ0A=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    hash = "sha256-DCR6KUAblVjhapqMn2p0nzndEJm4OCawGV3nAWZvSBs=";
  };
}
