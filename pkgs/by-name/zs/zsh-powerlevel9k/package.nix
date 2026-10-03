{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "powerlevel9k";
  version = "2017-11-10";
  src = fetchFromGitHub {
    owner = "Powerlevel9k";
    repo = "powerlevel9k";
    rev = "87acc51acab3ed4fd33cda2386abed6f98c80720";
    hash = "sha256-eDtP3Dk5jdrJbtRbAFVGmfeTnJNWPDo3m435DdPDLWw=";
  };

  strictDeps = true;
  installPhase = ''
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh/themes/powerlevel9k
    install -D functions/* --target-directory=$out/share/zsh/themes/powerlevel9k/functions
    ln -s $out/share/zsh/themes/powerlevel9k $out/share/zsh-powerlevel9k
  '';

  meta = {
    description = "Beautiful theme for zsh";
    longDescription = ''
      To make use of this derivation, use
      `programs.zsh.promptInit = "source ''${pkgs.zsh-powerlevel9k}/share/zsh-powerlevel9k/powerlevel9k.zsh-theme";`
    '';
    homepage = "https://github.com/Powerlevel9k/powerlevel9k";
    license = lib.licenses.mit;

    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.pierrechevalier83 ];
  };
}
