{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-vi-mode";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jeffreytse";
    repo = "zsh-vi-mode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EYr/jInRGZSDZj+QVAc9uLJdkKymx1tjuFBWgpsaCFw=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh-vi-mode
    cp *.zsh $out/share/zsh-vi-mode/
  '';

  meta = {
    description = "Better and friendly vi(vim) mode plugin for ZSH";
    homepage = "https://github.com/jeffreytse/zsh-vi-mode";
    changelog = "https://github.com/jeffreytse/zsh-vi-mode/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kyleondy
      starryreverie
    ];
    platforms = lib.platforms.all;
  };
})
