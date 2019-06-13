{ stdenv, google-fonts }:

stdenv.mkDerivation rec {
  name = "inconsolata-${version}";

  inherit (google-fonts) src version;

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D $src/ofl/inconsolata/*.ttf
  '';

  meta = with stdenv.lib; {
    homepage = https://www.levien.com/type/myfonts/inconsolata.html;
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [ mikoim raskin rycee ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
