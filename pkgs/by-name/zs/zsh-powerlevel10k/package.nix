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
  version = "1.20.15";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    # upstream doesn't seem to use tags anymore
    rev = "36f3045d69d1ba402db09d09eb12b42eebe0fa3b";
    hash = "sha256-BRJyGn+gTGUWifpJ1ziBKVHACcWw+R5N/HdUi8HzSvY=";
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

    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    cp -R gitstatus $out/share/zsh-powerlevel10k/gitstatus

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/romkatv/powerlevel10k/releases/tag/v${finalAttrs.version}";
    description = "Fast reimplementation of Powerlevel9k ZSH theme";
    longDescription = ''
      To make use of this derivation, use
      `programs.zsh.promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`
    '';
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ];
  };
})
