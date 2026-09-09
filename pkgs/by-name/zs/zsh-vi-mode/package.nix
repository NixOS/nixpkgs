{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsh-vi-mode";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "jeffreytse";
    repo = "zsh-vi-mode";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-EYr/jInRGZSDZj+QVAc9uLJdkKymx1tjuFBWgpsaCFw=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh-vi-mode
    cp *.zsh $out/share/zsh-vi-mode/
  '';

  meta = {
    homepage = "https://github.com/jeffreytse/zsh-vi-mode";
    license = lib.licenses.mit;
    description = "Better and friendly vi(vim) mode plugin for ZSH";
    maintainers = with lib.maintainers; [ kyleondy ];
    platforms = lib.platforms.all;
  };
})
