{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yew-fmt";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "its-the-shrimp";
    repo = "yew-fmt";
    tag = "v${version}";
    hash = "sha256-2sOw8wWfnEphYsruQyhZMW3KofcGkNHJB6Q1jhFP3oo=";
  };

  cargoHash = "sha256-o4oRVI3+Nz8fwdwlyVvXUuhCQr4Bbg5Kife/PJoJCJY=";
  nativeCheckInputs = [ rustfmt ];
  passthru.updateScript = nix-update-script { };
  useFetchCargoVendor = true;

  meta = {
    description = "Code formatter for the Yew framework";
    mainProgram = "yew-fmt";
    homepage = "https://github.com/its-the-shrimp/yew-fmt";
    changelog = "https://github.com/its-the-shrimp/yew-fmt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dandedotdev ];
  };
}
