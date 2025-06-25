{
  lib,
  rustfmt,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "yew-fmt";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "its-the-shrimp";
    repo = "yew-fmt";
    tag = "v${version}";
    hash = "sha256-kUelvhWUj9+nEHNWolhTJa8emdBInKV9cK2dF/H7dNQ=";
  };

  cargoHash = "sha256-oIliRYc6HU8KFmlTTIlV+nmeRUx1gJhy93QjPnGxiK8=";
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
