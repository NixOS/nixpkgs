{ lib, fetchzip }:

let
  version = "5.2";
in fetchzip {
  name = "fira-code-${version}";

  url = "https://github.com/tonsky/FiraCode/releases/download/${version}/Fira_Code_v${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile 'ttf/*.ttf' -d $out/share/fonts/truetype
  '';

  sha256 = "1mghf53yf6i7xn0gr2ixrd6mr7wcjy1y538i1k92c82qs7y2lb8j";

  meta = with lib; {
    homepage = "https://github.com/tonsky/FiraCode";
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
