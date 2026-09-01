{
  lib,
  stdenv,
  fetchFromGitHub,
}:

# To make use of this derivation, use the `programs.zsh.autosuggestions.enable` option

stdenv.mkDerivation (finalAttrs: {
  pname = "zsh-autosuggestions";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-autosuggestions";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-vpTyYq9ZgfgdDsWzjxVAE7FZH4MALMNZIFyEOBLm5Qo=";
  };

  strictDeps = true;

  installPhase = ''
    install -D zsh-autosuggestions.plugin.zsh \
      $out/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
    install -D zsh-autosuggestions.zsh \
      $out/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    ln -s $out/share/zsh/plugins/zsh-autosuggestions \
      $out/share/zsh-autosuggestions
  '';

  meta = {
    description = "Fish shell autosuggestions for Zsh";
    homepage = "https://github.com/zsh-users/zsh-autosuggestions";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.loskutov ];
  };
})
