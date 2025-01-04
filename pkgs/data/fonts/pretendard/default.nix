{
  lib,
  stdenvNoCC,
  fetchzip,
}:

let
  version = "1.3.9";

  mkPretendard =
    {
      pname,
      typeface,
      hash,
    }:
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
        description = "Alternative font to system-ui for all platforms";
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
    hash = "sha256-n7RQApffpL/8ojHcZbdxyanl9Tlc8HP8kxLFBdArUfY=";
  };

  pretendard-gov = mkPretendard {
    pname = "pretendard-gov";
    typeface = "PretendardGOV";
    hash = "sha256-qoDUBOmrk6WPKQgnapThfKC01xWup+HN82hcoIjEe0M=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    hash = "sha256-1nTk1LPoRSfSDgDuGWkcs6RRIY4ZOqDBPMsxezMos6Q=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    hash = "sha256-gkYqqxSICmSIrBuPRzBaOlGGM/rJU1z7FiFvu9RhK5s=";
  };
}
