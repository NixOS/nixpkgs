{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "wttrbar";
  version = "0.12.1";

  src = fetchFromGitHub {
    owner = "bjesus";
    repo = "wttrbar";
    rev = version;
    hash = "sha256-+EyjZZpDktkYbxy3YXAtuW3A0bEFKFa+UuRvIzUEISM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-AXyt5z1d26si7qLZgd7dWrHOOJBvK75B29/LJj7bpAo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple but detailed weather indicator for Waybar using wttr.in";
    homepage = "https://github.com/bjesus/wttrbar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
    mainProgram = "wttrbar";
  };
}
