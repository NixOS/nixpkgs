{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "zsh-fzf-history-search";
  version = "0-unstable-2025-11-08";

  src = fetchFromGitHub {
    owner = "joshskidmore";
    repo = "zsh-fzf-history-search";
    rev = "35df458f7d9478fa88c74af762dcd296cdfd485d";
    hash = "sha256-6UWmfFQ9JVyg653bPQCB5M4jJAJO+V85rU7zP4cs1VI=";
  };

  dontConfigure = true;
  dontBuild = true;
  strictDeps = true;

  installPhase = ''
    runHook preInstall

    install -D zsh-fzf-history-search*.zsh  --target-directory=$out/share/zsh-fzf-history-search

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Simple zsh plugin that replaces Ctrl+R with an fzf-driven select which includes date/times";
    homepage = "https://github.com/joshskidmore/zsh-fzf-history-search";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.Gliczy ];
  };
}
