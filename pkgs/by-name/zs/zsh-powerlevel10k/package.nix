{
  lib,
  stdenv,
  fetchFromGitHub,
  replaceVars,
  fetchpatch,
  gitstatus,
  bash,
}:

let
  # match gitstatus version with given `gitstatus_version`:
  # https://github.com/romkatv/powerlevel10k/blob/master/gitstatus/build.info
  gitstatus' = gitstatus.overrideAttrs (oldAtttrs: rec {
    version = "1.5.4";

    src = fetchFromGitHub {
      owner = "romkatv";
      repo = "gitstatus";
      rev = "refs/tags/v${version}";
      hash = "sha256-mVfB3HWjvk4X8bmLEC/U8SKBRytTh/gjjuReqzN5qTk=";
    };

    patches = (oldAtttrs.patches or [ ]) ++ [
      # remove when bumped to 1.5.5
      (fetchpatch {
        url = "https://github.com/romkatv/gitstatus/commit/62177e89b2b04baf242cd1526cc2661041dda0fb.patch";
        sha256 = "sha256-DSRYRV89MLR/Eh4MFsXpDKH1xJiAWyJgSqmfjDTXhtU=";
        name = "drop-Werror.patch";
      })
    ];

  });
in
stdenv.mkDerivation rec {
  pname = "powerlevel10k";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "romkatv";
    repo = "powerlevel10k";
    rev = "refs/tags/v${version}";
    hash = "sha256-ES5vJXHjAKw/VHjWs8Au/3R+/aotSbY7PWnWAMzCR8E=";
  };

  strictDeps = true;
  buildInputs = [ bash ];

  patches = [
    (replaceVars ./gitstatusd.patch {
      gitstatusdPath = "${gitstatus'}/bin/gitstatusd";
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
