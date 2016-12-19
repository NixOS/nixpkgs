{ stdenv, fetchurl, p7zip }:

stdenv.mkDerivation rec {
  name = "marathi-cursive-${version}";
  version = "1.2";

  src = fetchurl {
    url = "https://github.com/MihailJP/MarathiCursive/releases/download/${version}/MarathiCursive-${version}.7z";
    sha256 = "0zhqkkfkz5mhfz8xv305s16h80p9v1iva829fznxd2c44ngyplmc";
  };

  buildInputs = [ p7zip ];

  unpackCmd = "7z x $curSrc";

  installPhase = ''
    mkdir -p $out/share/fonts/marathi-cursive
    cp -v *.otf *.ttf $out/share/fonts/marathi-cursive
    mkdir -p $out/share/doc/${name}
    cp -v README *.txt $out/share/doc/${name}
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/MihailJP/marathi-cursive;
    description = "Modi script font with Graphite and OpenType support";
    maintainers = with maintainers; [ mathnerd314 ];
    license = licenses.mit; # It's the M+ license, M+ is MIT(-ish)
    platforms = platforms.all;
  };
}
