{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "toml2nix";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-YhluLS4tFMibFrDzgIvNtfjM5dAqJQvygeZocKn3+Jg=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

<<<<<<< HEAD
  meta = {
    description = "Tool to convert TOML files to Nix expressions";
    mainProgram = "toml2nix";
    homepage = "https://crates.io/crates/toml2nix";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Tool to convert TOML files to Nix expressions";
    mainProgram = "toml2nix";
    homepage = "https://crates.io/crates/toml2nix";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit # or
      asl20
    ];
    maintainers = [ ];
  };
}
