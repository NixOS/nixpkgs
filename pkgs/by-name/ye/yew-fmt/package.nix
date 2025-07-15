{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yew-fmt";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "its-the-shrimp";
    repo = "yew-fmt";
    tag = "v${version}";
    hash = "sha256-IrfL4t92neaJS8UybnHeAg9hShER6TLK1nuFqPHYoMg=";
  };

  cargoHash = "sha256-AvtrqqsUGW9qG+ZHd/PrCLAHKk9psS3tnd1SPkdsNXw=";
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
