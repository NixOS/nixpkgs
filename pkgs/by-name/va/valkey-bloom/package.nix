{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "valkey-bloom";
  version = "1.0.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "valkey-io";
    repo = "valkey-bloom";
    tag = finalAttrs.version;
    hash = "sha256-v7IjqPA0VdYrRa8DHgzROh6jjprVf1viiIJz11P+fi0=";
  };

  # Upstream doesn't provide a cargo lock file
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp --no-preserve=mode ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  # Requires custom memory allocator
  doCheck = false;

  meta = {
    changelog = "https://github.com/valkey-io/valkey-bloom/releases/tag/${finalAttrs.src.tag}";
    description = "Module which brings BloomFilter data type to Valkey";
    homepage = "https://github.com/valkey-io/valkey-bloom";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    teams = [ lib.teams.redis ];
  };
})
