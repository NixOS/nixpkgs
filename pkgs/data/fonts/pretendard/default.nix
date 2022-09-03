{ lib, fetchzip }:

let
  version = "1.3.3";

  mkPretendard = { pname, typeface, sha256 }:
    fetchzip {
      name = "${pname}-${version}";

      url = "https://github.com/orioncactus/pretendard/releases/download/v${version}/${typeface}-${version}.zip";
      inherit sha256;

      stripRoot = false;

      postFetch = ''
        mkdir -p $out/share/fonts/
        install -Dm644 $out/public/static/*.otf -t $out/share/fonts/opentype
        rm -rf $out/{public,web,LICENSE.txt}
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
    sha256 = "sha256-lRHRdCAg3i3+3Y6j0dCXUgwLdeS/VeI6KNkbDKchNEY=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    sha256 = "sha256-VgGt/WoaaJJDAzw+gUQVgTQ+q34bdAaKUB4cA9eU0dQ=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    sha256 = "sha256-FOlZrr6CHPfUm9Q+Yoi0HLQUI7cAhQYq6P6sJGXBIWg=";
  };
}
