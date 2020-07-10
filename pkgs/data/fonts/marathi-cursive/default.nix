{ lib, fetchzip }:

let
  version = "2.0";
in fetchzip rec {
  name = "marathi-cursive-${version}";

  url = "https://github.com/MihailJP/MarathiCursive/releases/download/v${version}/MarathiCursive-${version}.tar.xz";

  postFetch = ''
    tar -xJf $downloadedFile --strip-components=1
    install -m444 -Dt $out/share/fonts/marathi-cursive *.otf *.ttf
    install -m444 -Dt $out/share/doc/${name} README *.txt
  '';

  sha256 = "17pj60ajnjghxhxka8a046mz6vfwr79wnby7xd6pg5hgncin2hgg";

  meta = with lib; {
    homepage = "https://github.com/MihailJP/MarathiCursive";
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.mit; # It's the M+ license, M+ is MIT(-ish)
    platforms = platforms.all;
  };
}
