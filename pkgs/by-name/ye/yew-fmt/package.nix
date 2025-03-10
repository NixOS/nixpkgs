{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yew-fmt";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "its-the-shrimp";
    repo = "yew-fmt";
    tag = "v${version}";
    hash = "sha256-Ck6WA6ROm8APTsgoxbVGUqoblc5awW+hmmzcy4ZFoBM=";
  };

  cargoHash = "sha256-Fp8MT1LJ1EpqwEZ+SpOomqZ7we47w2S5ExkB966Z3r0=";
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
