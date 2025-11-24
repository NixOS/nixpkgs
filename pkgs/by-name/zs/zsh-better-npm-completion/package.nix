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
    sha256 = "16z7k5n1rcl9i61lrm7i5dsqsmhvdp1y4y5ii6hv2xpp470addgy";
  };

  strictDeps = true;
  installPhase = ''
    install -Dm 0644 zsh-better-npm-completion.plugin.zsh $out/share/zsh-better-npm-completion
  '';

  meta = with lib; {
    description = "Better completion for npm";
    homepage = "https://github.com/lukechilds/zsh-better-npm-completion";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.gerschtli ];
  };
}
