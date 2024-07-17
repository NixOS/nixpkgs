{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "inconsolata";
  version = "3.001";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "0f203e3740b5eb77e0b179dff1e5869482676782";
    sha256 = "sha256-Q8eUJ0mkoB245Ifz5ulxx61x4+AqKhG0uqhWF2nSLpw=";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D $src/ofl/inconsolata/static/*.ttf
  '';

  meta = with lib; {
    homepage = "https://www.levien.com/type/myfonts/inconsolata.html";
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [
      appsforartists
      mikoim
      raskin
    ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
