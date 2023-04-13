{ lib, stdenvNoCC, fetchzip }:

let
  version = "1.3.3";

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
    hash = "sha256-xCEZlwTPhrNIO6WODl55wo2oin+iMYOL/rVaEybpzr0=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    hash = "sha256-x0G7ULzkIJqZlK995+wWKHXZdWryUTRouGTa5LsJQzk=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    hash = "sha256-/I8LZhFB86/+o+IzUP+bSIq7scKPOL7k/6/Bom0ZSqg=";
  };
}
