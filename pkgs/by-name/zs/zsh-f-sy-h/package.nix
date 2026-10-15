{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-f-sy-h";
  version = "1.67";

  src = fetchFromGitHub {
    owner = "z-shell";
    repo = "F-Sy-H";
    rev = "v${version}";
    hash = "sha256-zhaXjrNL0amxexbZm4Kr5Y/feq1+2zW0O6eo9iZhmi0=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/site-functions"

    mkdir -p "$plugindir"
    cp -r -- F-Sy-H.plugin.zsh chroma functions share themes "$plugindir"/
  '';

  meta = {
    description = "Feature-rich Syntax Highlighting for Zsh";
    homepage = "https://github.com/z-shell/F-Sy-H";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ mrfreezeex ];
    platforms = lib.platforms.unix;
  };
}
