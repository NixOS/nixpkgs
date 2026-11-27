{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  gitstatus,
  bash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powerlevel10k";
  version = "1.21.0";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Plv/JqwPjat0JLW4sKw6KdoB2v4Ol0zSFIldHqj5ku0=";
  };

  strictDeps = true;

  buildInputs = [ bash ];

  patches = [
    (replaceVars ./gitstatusd.patch {
      gitstatusdPath = "${gitstatus}/bin/gitstatusd";
    })
  ];

  installPhase = ''
    runHook preInstall

    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh/themes/powerlevel10k
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh/themes/powerlevel10k
    install -D config/* --target-directory=$out/share/zsh/themes/powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh/themes/powerlevel10k/internal
    cp -R gitstatus $out/share/zsh/themes/powerlevel10k/gitstatus
    ln -s $out/share/zsh/themes/powerlevel10k $out/share/zsh-powerlevel10k

    runHook postInstall
  '';

  meta = {
    description = "Fast reimplementation of Powerlevel9k ZSH theme";
    longDescription = ''
      To make use of this derivation, use
      `programs.zsh.promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`
    '';
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ kamadorueda ];
  };
})
