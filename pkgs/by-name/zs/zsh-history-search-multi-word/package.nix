{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation rec {
  pname = "zsh-history-search-multi-word";
  version = "0-unstable-2021-11-13";

  src = fetchFromGitHub {
    owner = "zdharma-continuum";
    repo = "history-search-multi-word";
    rev = "5b44d8cea12351d91fbdc3697916556f59f14b8c";
    sha256 = "11r2mmy6bg3b6pf6qc0ml3idh333cj8yz754hrvd1sc4ipfkkqh7";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/${pname}"

    mkdir -p "$plugindir"
    cp -r -- history-* hsmw-* "$plugindir"/
  '';

  meta = with lib; {
    description = "Multi-word, syntax highlighted history searching for Zsh";
    homepage = "https://github.com/zdharma-continuum/history-search-multi-word";
    license = with licenses; [
      gpl3
      mit
    ];
    platforms = platforms.unix;
  };
}
