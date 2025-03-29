{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yew-fmt";
  version = "0.6";

  src = fetchFromGitHub {
    owner = "its-the-shrimp";
    repo = "yew-fmt";
    tag = "v${version}";
    hash = "sha256-KhZezkR9VhdfGkNe1hSF90pe9K4VGDlBltasb7xnmRI=";
  };

  cargoHash = "sha256-Y6OicST0GbUL4RpvdvtBLFlLwryQMKlaut5x9+cNiM8=";
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
