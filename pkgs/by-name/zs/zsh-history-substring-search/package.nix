{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zsh-history-substring-search";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-history-substring-search";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GSEvgvgWi1rrsgikTzDXokHTROoyPRlU0FVpAoEmXG4=";
  };

  strictDeps = true;
  installPhase = ''
    install -D zsh-history-substring-search.plugin.zsh \
      "$out/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh"
    install -D zsh-history-substring-search.zsh \
      "$out/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
    ln -s $out/share/zsh/plugins/zsh-history-substring-search \
      $out/share/zsh-history-substring-search
  '';

  meta = {
    description = "Fish shell history-substring-search for Zsh";
    homepage = "https://github.com/zsh-users/zsh-history-substring-search";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ qyliss ];
    platforms = lib.platforms.unix;
  };
})
