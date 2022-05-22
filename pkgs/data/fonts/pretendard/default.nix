{ lib, fetchzip }:

let
  version = "1.3.0";

  mkPretendard = { pname, typeface, sha256 }:
    fetchzip {
      name = "${pname}-${version}";

      url = "https://github.com/orioncactus/pretendard/releases/download/v${version}/${typeface}-${version}.zip";
      inherit sha256;

      postFetch = ''
        mkdir -p $out/share/fonts/opentype
        unzip -j $downloadedFile "*.otf" -d $out/share/fonts/opentype
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
    sha256 = "sha256-4DM8PZjxW93sgQChs+qu5Svo+iGlFnpglu6acYMCkSQ=";
  };

  pretendard-jp = mkPretendard {
    pname = "pretendard-jp";
    typeface = "PretendardJP";
    sha256 = "sha256-3OOUUDiurCpIGNIVjrr2KW0CB3fCXt11P+13teK5kOQ=";
  };

  pretendard-std = mkPretendard {
    pname = "pretendard-std";
    typeface = "PretendardStd";
    sha256 = "sha256-iVAPdA6qAiE7pseaB0NKPJBPNGdw/nT6PzXIsLajJH4=";
  };
}
