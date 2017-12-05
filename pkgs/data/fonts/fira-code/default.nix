{ stdenv, fetchzip }:

let
  version = "1.204";
in fetchzip {
  name = "fira-code-${version}";

  url = "https://github.com/tonsky/FiraCode/releases/download/${version}/FiraCode_${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "0gngbnrq42ysz13w3s227ghv1yigw399r3w2415ipb5pba8vipad";

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
