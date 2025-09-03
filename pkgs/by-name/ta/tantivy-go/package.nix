{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "tantivy-go";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "tantivy-go";
    tag = "v${version}";
    hash = "sha256-iTGIm5C7SMBZv2OcKCQCyEZS/eeMJQ5nFSpuFJbTEXU=";
  };

  cargoHash = "sha256-f8xI4g6MK4NUn0DpxD+miaCzBe8FSSqaL5rpjoqUGfY=";

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
