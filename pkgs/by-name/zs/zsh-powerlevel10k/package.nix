{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  gitstatus,
  bash,
}:

stdenv.mkDerivation rec {
  pname = "powerlevel10k";
  version = "1.20.14";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    # upstream doesn't seem to use tags anymore
    rev = "5e26473457d819fe148f7fff32db1082dae72012";
    hash = "sha256-/+FEkgBR6EOTaCAc15vYGWNih2QZkN27ae6LMXlXZU4=";
  };

  strictDeps = true;
  buildInputs = [ bash ];

  patches = [
    (replaceVars ./gitstatusd.patch {
      gitstatusdPath = "${gitstatus}/bin/gitstatusd";
    })
  ];

  installPhase = ''
    install -D powerlevel10k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D powerlevel9k.zsh-theme --target-directory=$out/share/zsh-powerlevel10k
    install -D config/* --target-directory=$out/share/zsh-powerlevel10k/config
    install -D internal/* --target-directory=$out/share/zsh-powerlevel10k/internal
    cp -R gitstatus $out/share/zsh-powerlevel10k/gitstatus
  '';

  meta = {
    changelog = "https://github.com/romkatv/powerlevel10k/releases/tag/v${version}";
    description = "Fast reimplementation of Powerlevel9k ZSH theme";
    longDescription = ''
      To make use of this derivation, use
      `programs.zsh.promptInit = "source ''${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";`
    '';
    homepage = "https://github.com/romkatv/powerlevel10k";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
