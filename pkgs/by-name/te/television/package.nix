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
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "alexpasmantier";
    repo = "television";
    tag = finalAttrs.version;
    hash = "sha256-4auc5iZJCF1e3nPyLpZb8wSy5/PAKDV+mkHjIm5vCF8=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-HJXNRsLKYAJq/SpXRj0sw47CvRNxif7K7n/GuWG8F+8=";

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
