import ./generic.nix {
  version = "0.1.0-beta.3";
  hash = "sha256-0p+1cMn9PU+Jk2JW7G+sdzxhMaI3gEAk5w2nm05oBSU=";
  outputHashes = {
    "uniffi-0.21.0" = "sha256-blKCfCsSNtr8NtO7Let7VJ/9oGuW9Eu8j9A6/oHUcP0=";
  };
  cargoLock = ./Cargo-beta.3.lock;
  patches = [
    # This is needed because two versions of indexed_db_futures are present (which will fail to vendor, see https://github.com/rust-lang/cargo/issues/10310).
    # (matrix-sdk-crypto-nodejs doesn't use this dependency, we only need to remove it to vendor the dependencies successfully.)
    ./remove-duplicate-dependency.patch
  ];
}
