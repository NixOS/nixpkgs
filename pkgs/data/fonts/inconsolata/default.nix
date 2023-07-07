{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "inconsolata";
  version = "unstable-2021-01-19";

  src = fetchFromGitHub {
    owner = "google";
    repo = "fonts";
    rev = "f113126dc4b9b1473d9354a86129c9d7b837aa1a";
    sha256 = "0safw5prpa63mqcyfw3gr3a535w4c9hg5ayw5pkppiwil7n3pyxs";
  };

  installPhase = ''
    install -m644 --target $out/share/fonts/truetype/inconsolata -D $src/ofl/inconsolata/*.ttf
  '';

  meta = with lib; {
    homepage = "https://www.levien.com/type/myfonts/inconsolata.html";
    description = "A monospace font for both screen and print";
    maintainers = with maintainers; [ mikoim raskin ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
