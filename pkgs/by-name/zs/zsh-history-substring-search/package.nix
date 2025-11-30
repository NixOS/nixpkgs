{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "zsh-history-substring-search";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "zsh-users";
    repo = "zsh-history-substring-search";
    rev = "v${version}";
    sha256 = "0vjw4s0h4sams1a1jg9jx92d6hd2swq4z908nbmmm2qnz212y88r";
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

  meta = with lib; {
    description = "Fish shell history-substring-search for Zsh";
    homepage = "https://github.com/zsh-users/zsh-history-substring-search";
    license = licenses.bsd3;
    maintainers = with maintainers; [ qyliss ];
    platforms = platforms.unix;
  };
}
