{ lib, fetchzip, p7zip }:

let
  version = "1.2";
in fetchzip rec {
  name = "marathi-cursive-${version}";

  url = "https://github.com/MihailJP/MarathiCursive/releases/download/${version}/MarathiCursive-${version}.7z";

  postFetch = ''
    ${p7zip}/bin/7z x $downloadedFile
    cd MarathiCursive

    install -m444 -Dt $out/share/fonts/marathi-cursive *.otf *.ttf
    install -m444 -Dt $out/share/doc/${name}           README *.txt
  '';

  sha256 = "0wq4w79x8r5w6ikm9amcmapf0jcdgifs9zf1pbnw3fk4ncz5s551";

  meta = with lib; {
    homepage = https://github.com/MihailJP/MarathiCursive;
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.mit; # It's the M+ license, M+ is MIT(-ish)
    platforms = platforms.all;
  };
}
