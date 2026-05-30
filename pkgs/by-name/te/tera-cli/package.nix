{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tera-cli";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "chevdor";
    repo = "tera-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TN3zkxZC0Y9lev2wmvzwyLU+t4rNwut/dQILIA7+qbw=";
  };

  cargoHash = "sha256-+qf/MlifpVXzDpADJoTqxU40wDntcPu+bW7eq6/iubk=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command line utility to render templates from json|toml|yaml and ENV, using the tera templating engine";
    homepage = "https://github.com/chevdor/tera-cli";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers._365tuwe ];
    mainProgram = "tera";
    platforms = lib.platforms.unix;
  };
})
