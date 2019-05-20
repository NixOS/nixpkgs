{ stdenv, fetchurl, google-fonts, migu, fontforge, which }:

stdenv.mkDerivation rec {
  name = "ricty-${version}";
  version = "4.1.1";

  src = fetchurl {
      url = "https://www.rs.tus.ac.jp/yyusa/ricty/ricty_generator-${version}.sh";
      sha256 = "03fngb8f5hl7ifigdm5yljhs4z2x80cq8y8kna86d07ghknhzgw6";
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
    homepage = https://www.rs.tus.ac.jp/yyusa/ricty.html;
    license = licenses.unfree;
    maintainers = [ maintainers.mikoim ];
  };
}

