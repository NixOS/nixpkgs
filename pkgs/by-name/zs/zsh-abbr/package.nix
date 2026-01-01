{
  stdenv,
  lib,
  fetchFromGitHub,
  installShellFiles,
}:
stdenv.mkDerivation rec {
  pname = "zsh-abbr";
<<<<<<< HEAD
  version = "6.4.0";
=======
  version = "6.3.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "olets";
    repo = "zsh-abbr";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-nfkXtRZ7CB/MnmzMe1ivKz26Vv5duP4zTAv7EZwpMTM=";
=======
    hash = "sha256-vu17UAainZDD+8y/t+vBdGUe2NTF5XZdnHy5T15pNUE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  strictDeps = true;
  nativeBuildInputs = [ installShellFiles ];

  installPhase = ''
    runHook preInstall

    install *.zsh -Dt $out/share/zsh/zsh-abbr/
    install completions/* -Dt $out/share/zsh/zsh-abbr/completions/

    install zsh-job-queue/*.zsh -Dt $out/share/zsh/zsh-abbr/zsh-job-queue/
    install zsh-job-queue/completions/* -Dt $out/share/zsh/zsh-abbr/zsh-job-queue/completions/

    # Required for `man` to find the manpage of abbr, since it looks via PATH
    installManPage man/man1/*

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/olets/zsh-abbr";
    description = "Zsh manager for auto-expanding abbreviations, inspired by fish shell";
    license = with lib.licenses; [
      cc-by-nc-sa-40
      hl3
    ];
    maintainers = with lib.maintainers; [ icy-thought ];
    platforms = lib.platforms.all;
=======
  meta = with lib; {
    homepage = "https://github.com/olets/zsh-abbr";
    description = "Zsh manager for auto-expanding abbreviations, inspired by fish shell";
    license = with licenses; [
      cc-by-nc-sa-40
      hl3
    ];
    maintainers = with maintainers; [ icy-thought ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
