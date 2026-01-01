{
  lib,
  stdenvNoCC,
  ncurses,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "zsh-you-should-use";
<<<<<<< HEAD
  version = "1.10.1";
=======
  version = "1.10.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "MichaelAquilina";
    repo = "zsh-you-should-use";
    tag = finalAttrs.version;
<<<<<<< HEAD
    hash = "sha256-u3abhv9ewq3m4QsnsxT017xdlPm3dYq5dqHNmQhhcpI=";
=======
    hash = "sha256-dG6E6cOKu2ZvtkwxMXx/op3rbevT1QSOQTgw//7GmSk=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/MichaelAquilina/zsh-you-should-use/blob/${finalAttrs.src.tag}/CHANGELOG.md";
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.gpl3;
    description = "ZSH plugin that reminds you to use existing aliases for commands you just typed";
    maintainers = with lib.maintainers; [ tomodachi94 ];
  };
})
