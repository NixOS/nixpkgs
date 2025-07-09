{
  lib,
  rustPlatform,
  fetchFromGitHub,
  testers,
  television,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "television";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "television";
    tag = finalAttrs.version;
    hash = "sha256-J4z0QKw4P2auIbp6SU+XsA/hCJJCN5WUIVwZJAICSrs=";
  };

  postPatch = ''
    substituteInPlace tests/common/mod.rs --replace-fail './target/debug/tv' '${rustPlatform.cargoInstallHook.targetSubdirectory}/tv'
  '';

  cargoHash = "sha256-ASJ3QXe4AqEtTdezwWvWvTIdKazQv+1Hr9gcjG6HcsE=";

  checkType = "debug";

  passthru = {
    tests.version = testers.testVersion {
      package = television;
      command = "XDG_DATA_HOME=$TMPDIR tv --version";
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Blazingly fast general purpose fuzzy finder TUI";
    longDescription = ''
      Television is a fast and versatile fuzzy finder TUI.
      It lets you quickly search through any kind of data source (files, git
      repositories, environment variables, docker images, you name it) using a
      fuzzy matching algorithm and is designed to be easily extensible.
    '';
    homepage = "https://github.com/alexpasmantier/television";
    changelog = "https://github.com/alexpasmantier/television/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "tv";
    maintainers = with lib.maintainers; [
      louis-thevenet
      getchoo
    ];
  };
})
