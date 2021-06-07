{ lib, stdenv, google-fonts }:

stdenv.mkDerivation {
  pname = "inconsolata";

  inherit (google-fonts) src version;

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D $src/ofl/inconsolata/static/*.ttf
  '';

  meta = with lib; {
    homepage = "https://www.levien.com/type/myfonts/inconsolata.html";
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [ mikoim raskin ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
