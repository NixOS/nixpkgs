{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-completion-sync";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "BronzeDeer";
    repo = "zsh-completion-sync";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-GTW4nLVW1/09aXNnZJuKs12CoalzWGKB79VsQ2a2Av4=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D zsh-completion-sync.plugin.zsh  $out/share/zsh-completion-sync/zsh-completion-sync.plugin.zsh
  '';

  meta = {
    description = "Automatically loads completions added dynamically to FPATH or XDG_DATA_DIRS";
    homepage = "https://github.com/BronzeDeer/zsh-completion-sync";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      ambroisie
      BronzeDeer
    ];
  };
})
