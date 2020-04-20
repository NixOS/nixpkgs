{ stdenv, fetchzip }:

let
  version = "3.1";
in fetchzip {
  name = "fira-code-${version}";

  url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode_${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
  '';

  sha256 = "1rk5hiix282b1gsxq9kqma2q9fnydj0xl9vbrd88rf7ywvn75817";

  meta = with stdenv.lib; {
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
