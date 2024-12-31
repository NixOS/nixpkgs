{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-fast-syntax-highlighting";
  version = "1.55";

  src = fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = "fast-syntax-highlighting";
    rev = "v${version}";
    sha256 = "0h7f27gz586xxw7cc0wyiv3bx0x3qih2wwh05ad85bh2h834ar8d";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/site-functions"

    mkdir -p "$plugindir"
    cp -r -- {,_,-,.}fast-* *chroma themes "$plugindir"/
  '';

  meta = with lib; {
    description = "Syntax-highlighting for Zshell";
    homepage = "https://github.com/zdharma-continuum/fast-syntax-highlighting";
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
