{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tantivy-go";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "tantivy-go";
    tag = "v${version}";
    hash = "sha256-uOL/waiZKei4f+pRz9i5OowWIT9FJ+gQWgHlANjSQII=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-CF1UKff+u26pwZHOiuzzWSaqA1vK7Sup3aXxFK08Vvk=";

  cargoPatches = [
    ./add-Cargo.lock.patch
  ];

  cargoRoot = "rust";
  buildAndTestSubdir = cargoRoot;

  meta = {
    description = "Tantivy go bindings";
    homepage = "https://github.com/anyproto/tantivy-go";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      autrimpo
      adda
    ];
  };
}
