{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

<<<<<<< HEAD
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "systemctl-tui";
  version = "0.4.1";
=======
rustPlatform.buildRustPackage rec {
  pname = "systemctl-tui";
  version = "0.4.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "rgwood";
    repo = "systemctl-tui";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-OzOc0osaKoRVuo+fBJOhsZAiFfm0ZHj6POUjRaIZGsc=";
  };

  cargoHash = "sha256-MSpex0G1RJsI5RCrAlSgeY2/6flndwCjdtopWfuXNts=";
=======
    tag = "v${version}";
    hash = "sha256-1KYaw4q1+dPHImjjCnUPXNu7ihdEfNuzQfHfPi1uDOw=";
  };

  cargoHash = "sha256-rOmoV8sHeoM2ypDlBbiLDIYHhFQZJ6T2D5VkSNW+uuc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
<<<<<<< HEAD
=======
  versionCheckProgramArg = "--version";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script;
  };

  meta = {
    description = "Simple TUI for interacting with systemd services and their logs";
    homepage = "https://crates.io/crates/systemctl-tui";
<<<<<<< HEAD
    changelog = "https://github.com/rgwood/systemctl-tui/releases/tag/v${finalAttrs.version}";
=======
    changelog = "https://github.com/rgwood/systemctl-tui/releases/tag/v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siph ];
    mainProgram = "systemctl-tui";
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
