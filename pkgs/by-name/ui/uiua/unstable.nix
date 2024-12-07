import ./generic.nix {
  pname = "uiua-unstable";
  version = "0.14.0-dev.6";
  hash = "sha256-YRv4i014xD4d8YN5PuMsa06+7kZgISPBGkKrVLU5ZN0=";
  cargoHash = "sha256-/CQD74mJUwGAiRf59YAznqYYHJtJEqDIFvSrVhvuuHs=";
  updateScript = ./update-unstable.sh;
}
