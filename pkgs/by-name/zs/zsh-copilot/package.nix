{
  lib,
  stdenvNoCC,
  fetchFromGitea,
  jq,
  curl,
  makeWrapper,
}:
stdenvNoCC.mkDerivation {
  pname = "zsh-copilot";
  version = "0-unstable-2025-06-21";

  src = fetchFromGitea {
    domain = "git.myzel394.app";
    owner = "Myzel394";
    repo = "zsh-copilot";
    rev = "be5b24d5bec678baf6c88fec1d8282a50fa7a8a1";
    hash = "sha256-kvkS2BxwyP68tSjV9KZtaqaj7FB2ZjoZYEKqN5pzZzU";
  };

  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];
  installPhase = ''
    runHook preInstall
    install -D $src/zsh-copilot.plugin.zsh --target-directory $out/share/zsh/plugins/zsh-copilot
    runHook postInstall
  '';

  meta = {
    description = "The Copilot that lives in your shell. Type in your thoughts, press ^Z and let the AI do it's magic";
    homepage = "https://git.myzel394.com/Myzel394/zsh-copilot";
    maintainers = [ lib.maintainers.myzel394 ];
    platforms = lib.platforms.unix;
  };
}
