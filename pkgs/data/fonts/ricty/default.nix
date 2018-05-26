{ stdenv, fetchurl, google-fonts, migu, fontforge, which }:

stdenv.mkDerivation rec {
  name = "ricty-${version}";
  version = "4.1.0";

  src = fetchurl {
      url = "http://www.rs.tus.ac.jp/yyusa/ricty/ricty_generator-${version}.sh";
      sha256 = "1cv0xh81fi6zdjb62zqjw46kbc89jvwbyllw1x1xbnpz2il6aavf";
  };

  unpackPhase = ''
    install -m 0770 $src ricty_generator.sh
  '';

  patchPhase = ''
    sed -i 's/fonts_directories=".*"/fonts_directories="$inconsolata $migu"/' ricty_generator.sh
  '';

  buildInputs = [ google-fonts migu fontforge which ];

  buildPhase = ''
    inconsolata=${google-fonts} migu=${migu} ./ricty_generator.sh auto
  '';

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/ricty -D Ricty-*.ttf
  '';

  meta = with stdenv.lib; {
    description = "A high-quality Japanese font based on Inconsolata and Migu 1M";
    homepage = http://www.rs.tus.ac.jp/yyusa/ricty.html;
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = [ maintainers.mikoim ];
  };
}

