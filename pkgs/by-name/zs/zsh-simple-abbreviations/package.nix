{
  stdenvNoCC,
  lib,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-simple-abbreviations";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "DeveloperC286";
    repo = "zsh-simple-abbreviations";
    rev = "v${finalAttrs.version}";
    sha256 = "15vax5nl90yw1wi1s31j0hi6f5j09v9gqkgszzhl764r1c0s47rr";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -Dm644 zsh-simple-abbreviations.zsh "$out/share/${finalAttrs.pname}/${finalAttrs.pname}.zsh"
    mkdir -p "$out/share/${finalAttrs.pname}"
    cp -R src "$out/share/${finalAttrs.pname}/"
  '';

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "A simple manager for abbreviations in Z shell (Zsh).";
    homepage = "https://github.com/DeveloperC286/zsh-simple-abbreviations";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      DeveloperC286
    ];
  };
})
