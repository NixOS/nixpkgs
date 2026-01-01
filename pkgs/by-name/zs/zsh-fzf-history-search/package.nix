{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
<<<<<<< HEAD
  unstableGitUpdater,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

stdenvNoCC.mkDerivation {
  pname = "zsh-fzf-history-search";
<<<<<<< HEAD
  version = "0-unstable-2025-11-08";
=======
  version = "0-unstable-2024-05-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "joshskidmore";
    repo = "zsh-fzf-history-search";
<<<<<<< HEAD
    rev = "35df458f7d9478fa88c74af762dcd296cdfd485d";
    hash = "sha256-6UWmfFQ9JVyg653bPQCB5M4jJAJO+V85rU7zP4cs1VI=";
=======
    rev = "d5a9730b5b4cb0b39959f7f1044f9c52743832ba";
    hash = "sha256-tQqIlkgIWPEdomofPlmWNEz/oNFA1qasILk4R5RWobY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontConfigure = true;
  dontBuild = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -D zsh-fzf-history-search*.zsh  --target-directory=$out/share/zsh-fzf-history-search

    runHook postInstall
  '';

<<<<<<< HEAD
  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Simple zsh plugin that replaces Ctrl+R with an fzf-driven select which includes date/times";
    homepage = "https://github.com/joshskidmore/zsh-fzf-history-search";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
<<<<<<< HEAD
    maintainers = [ lib.maintainers.Gliczy ];
=======
    maintainers = [ ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
