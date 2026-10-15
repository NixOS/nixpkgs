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
    hash = "sha256-B+I53Y2E6dB2hqSc75FkYwzY4qAVMGzcNWu8ZXytIoc=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    plugindir="$out/share/zsh/${pname}"

    mkdir -p "$plugindir"
    cp -r -- history-* hsmw-* "$plugindir"/
  '';

  meta = {
    description = "Multi-word, syntax highlighted history searching for Zsh";
    homepage = "https://github.com/zdharma-continuum/history-search-multi-word";
    license = with lib.licenses; [
      gpl3
      mit
    ];
    platforms = lib.platforms.unix;
  };
}
