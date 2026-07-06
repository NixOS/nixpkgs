{
  lib,
  fetchFromGitHub,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tera-cli";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "chevdor";
    repo = "tera-cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-//uF959hXiEL+jIGmQ5OnjYT4Z2jyzflxxIoF+hLnlk=";
  };

  cargoHash = "sha256-6NzX8dODW106AjTneDSsZWRoPYvNrv5tUCGUanod+Bo=";

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
