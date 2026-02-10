{
  lib,
  stdenvNoCC,
  ncurses,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-you-should-use";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = "zsh-you-should-use";
    tag = finalAttrs.version;
    hash = "sha256-u3abhv9ewq3m4QsnsxT017xdlPm3dYq5dqHNmQhhcpI=";
  };

  strictDeps = true;
  dontBuild = true;

  postPatch = ''
    substituteInPlace you-should-use.plugin.zsh \
      --replace-fail "tput" "${lib.getExe' ncurses "tput"}"
  '';

  installPhase = ''
    install -D you-should-use.plugin.zsh $out/share/zsh/plugins/you-should-use/you-should-use.plugin.zsh
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/MichaelAquilina/zsh-you-should-use";
    changelog = "https://github.com/MichaelAquilina/zsh-you-should-use/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.gpl3;
    description = "ZSH plugin that reminds you to use existing aliases for commands you just typed";
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
})
