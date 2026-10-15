{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "zsh-better-npm-completion";
  version = "0-unstable-2019-11-19";

  src = fetchFromGitHub {
    owner = "lukechilds";
    repo = "zsh-better-npm-completion";
    rev = "0a7cf042415324ec38a186fdcbc9af163f0d7e69";
    hash = "sha256-/rWmwCH3drGhibF44sNtG1aNdSvx1EyDiYmyHGyZ55s=";
  };

  strictDeps = true;
  installPhase = ''
    install -Dm 0644 zsh-better-npm-completion.plugin.zsh $out/share/zsh-better-npm-completion
  '';

  meta = {
    description = "Better completion for npm";
    homepage = "https://github.com/lukechilds/zsh-better-npm-completion";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.gerschtli ];
  };
}
