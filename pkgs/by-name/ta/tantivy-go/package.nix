{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tantivy-go";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "tantivy-go";
    tag = "v${version}";
    hash = "sha256-ksHw+62JwQrzxLuXwYfTLOkC22Miz1Rpl5XX8+vPBcM=";
  };

  cargoHash = "sha256-GKbQFWXKEgYmoTyFCQ/SAgFB7UJpYN2SWwZEiUxd260=";

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
