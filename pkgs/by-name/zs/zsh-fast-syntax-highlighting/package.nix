{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-fast-syntax-highlighting";
  version = "1.56";

  src = fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = "fast-syntax-highlighting";
    rev = "v${version}";
    sha256 = "sha256-caVMOdDJbAwo8dvKNgwwidmxOVst/YDda7lNx2GvOjY=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/plugins/fast-syntax-highlighting"

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
