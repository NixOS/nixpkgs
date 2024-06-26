import ./generic.nix {
  version = "0.1.0-beta.6";
  hash = "sha256-0oLk7yq/XELS0GkeZj7PxY3KKXfzws0djF3KmxYisY0=";
  outputHashes = {
    "ruma-0.8.2" = "sha256-bKvcElIVugj+gZZhPFPGfCqva4fo1IqW/e9gf+q/Tfw=";
    "uniffi-0.23.0" = "sha256-4WUp3PQm3ZgqHNMvz9+PBtNAeiq6m4PBViwXpQDglLk=";
    "vodozemac-0.3.0" = "sha256-tAimsVD8SZmlVybb7HvRffwlNsfb7gLWGCplmwbLIVE=";
  };
  cargoLock = ./Cargo-beta.6.lock;
  patches = [ ];
}
