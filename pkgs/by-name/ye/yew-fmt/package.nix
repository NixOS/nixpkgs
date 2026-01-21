{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yew-fmt";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "its-the-shrimp";
    repo = "yew-fmt";
    tag = "v${version}";
    hash = "sha256-bhguDpLRn51NWL/N2CT9tsNS8+RbaL37liCBeUe0ZyY=";
  };

  cargoHash = "sha256-QcqpAWsMhTKTBV4kCKhG/9b+l3Kh6gj/o78/w6it+K8=";
  nativeCheckInputs = [ rustfmt ];
  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code formatter for the Yew framework";
    mainProgram = "yew-fmt";
    homepage = "https://github.com/its-the-shrimp/yew-fmt";
    changelog = "https://github.com/its-the-shrimp/yew-fmt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dandedotdev ];
  };
}
