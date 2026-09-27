{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-z";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "agkozak";
    repo = "zsh-z";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r12crTTTYRYztuTCz7/59d4ig/O1x+I7lvf4r+b2fFM=";
  };

  strictDeps = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/zsh-z
    cp _zshz zsh-z.plugin.zsh $out/share/zsh-z
  '';

  meta = {
    description = "Jump quickly to directories that you have visited frequently in the past, or recently";
    homepage = "https://github.com/agkozak/zsh-z";
    changelog = "https://github.com/agkozak/zsh-z/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.evalexpr ];
  };
})
