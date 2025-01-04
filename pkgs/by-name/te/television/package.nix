{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  television,
  nix-update-script,
}:
rustPlatform.buildRustPackage rec {
  pname = "television";
  version = "0.8.5";

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "television";
    rev = "refs/tags/" + version;
    hash = "sha256-LzO6LpKsox5U2IHYZXDDkUbPeZmAa/gBpG6nk78tIzQ=";
  };

  cargoHash = "sha256-I0muMgPfk72dnR4iufipjt+C7v6X/IMOdLCH12qHjA8=";

  passthru = {
    tests.version = testers.testVersion {
      package = television;
      command = "XDG_DATA_HOME=$TMPDIR tv --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Television is a blazingly fast general purpose fuzzy finder";

    longDescription = ''
      Television is a blazingly fast general purpose fuzzy finder TUI written
      in Rust. It is inspired by the neovim telescope plugin and is designed
      to be fast, efficient, simple to use and easily extensible. It is built
      on top of tokio, ratatui and the nucleo matcher used by the helix editor.
    '';

    homepage = "https://github.com/alexpasmantier/television";
    changelog = "https://github.com/alexpasmantier/television/releases/tag/${version}";
    license = lib.licenses.mit;
    mainProgram = "tv";
    maintainers = with lib.maintainers; [
      louis-thevenet
      getchoo
    ];
  };
}
