{ stdenv, fetchzip }:

let
  version = "1.207";
in fetchzip {
  name = "fira-code-${version}";

  url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode_${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "13w2jklqndria2plgangl5gi56v1cj5ja9vznh9079kqnvq0cffz";

  meta = with stdenv.lib; {
    homepage = https://github.com/tonsky/FiraCode;
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
