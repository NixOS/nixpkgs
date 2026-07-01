{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  mold,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "zerostack";
  version = "1.5.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "gi-dellav";
    repo = "zerostack";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CLBb7SaSaE4kpQqTOWdjneg9smszE5uJfvNJ8fQDmrg=";
  };

  cargoHash = "sha256-qBKvYXLmAMj42/ZAgxWHgRFZwzEYaY8biiUwqt/TEyo=";

  nativeBuildInputs = [
    pkg-config
    mold
  ];

  buildInputs = [ openssl ];

  # needs HOME for test run
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  # tests share a global TODO_LIST mutex and race under parallelism
  dontUseCargoParallelTests = true;
  checkFlags = [ "--test-threads=1" ];

  buildFeatures = [
    "acp"
    "memory"
    "multithread"
  ];

  meta = {
    description = "Minimalistic coding agent written in Rust, optimized for memory footprint and performance";
    homepage = "https://github.com/gi-dellav/zerostack";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ TheCodedKid ];
    mainProgram = "zerostack";
    platforms = lib.platforms.unix;
  };
})
