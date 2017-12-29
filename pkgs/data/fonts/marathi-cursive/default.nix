{ stdenv, fetchzip, p7zip }:

let
  version = "1.2";
in fetchzip rec {
  name = "marathi-cursive-${version}";

  url = "https://github.com/MihailJP/MarathiCursive/releases/download/${version}/MarathiCursive-${version}.7z";

  postFetch = ''
    ${p7zip}/bin/7z x $downloadedFile
    cd MarathiCursive

    mkdir -p $out/share/fonts/marathi-cursive
    cp -v *.otf *.ttf $out/share/fonts/marathi-cursive
    mkdir -p $out/share/doc/${name}
    cp -v README *.txt $out/share/doc/${name}
  '';

  sha256 = "0fhz2ixrkm523qlx5pnwyzxgb1cfiiwrhls98xg8a5l3sypn1g8v";

  meta = with stdenv.lib; {
    homepage = https://github.com/MihailJP/MarathiCursive;
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.mit; # It's the M+ license, M+ is MIT(-ish)
    platforms = platforms.all;
  };
}
