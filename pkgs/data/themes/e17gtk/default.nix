{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "e17gtk";
  version = "3.22.2";

  src = fetchFromGitHub {
    owner = "tsujan";
    repo = "E17gtk";
    rev = "V${version}";
    sha256 = "1qwj1hmdlk8sdqhkrh60p2xg4av1rl0lmipdg5j0i40318pmiml1";
  };

  installPhase = ''
    mkdir -p $out/share/{doc,themes}/E17gtk
    cp -va index.theme gtk-2.0 gtk-3.0 metacity-1 $out/share/themes/E17gtk/
    cp -va README.md WORKAROUNDS screenshot.jpg $out/share/doc/E17gtk/
  '';

  meta = {
    description = "An Enlightenment-like GTK theme with sharp corners";
    homepage = "https://github.com/tsujan/E17gtk";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.romildo ];
  };
}
