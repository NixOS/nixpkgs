{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "cyberpunk-neon";
  version = "unstable-2021-02-02";

  src = fetchFromGitHub {
    owner = "Roboron3042";
    repo = "Cyberpunk-Neon";
    rev = "b4b293c7de87688841d504cb9a983e67d97749f3";
    sha256 = "sha256-yqr4xga4hzd+BJpEECPK0xQDP3CjABfJISQS684SbwM=";
  };

  dontBuild = true;

  installPhase = ''
    # gtk
    mkdir -p $out/share/themes
    tar xzf gtk/materia-cyberpunk-neon.tar.gz -C $out/share/themes/
    tar xzf gtk/arc-cyberpunk-neon.tar.gz -C $out/share/themes/

    # kde
    mkdir -p $out/share/color-schemes
    cp kde/cyberpunk-neon.colors $out/share/color-schemes/

    # terminal
    mkdir -p $out/share/konsole
    cp terminal/konsole/cyberpunk-neon.colorscheme $out/share/konsole
    mkdir -p $out/share/tilix/schemes
    cp terminal/tilix/cyberpunk-neon.json $out/share/tilix/schemes
  '';

  meta = with lib; {
    description = "Themes for KDE Plasma, GTK, Telegram, Tilix, Vim, Zim and more.";
    license = licenses.cc-by-sa-40;
    platforms = platforms.unix;
    maintainers = [ maintainers.rpgwaiter ];
  };
}
