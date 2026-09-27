{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  protobuf,
  unstableGitUpdater,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  pname = "vecstore";
  version = "0.1.0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "PhilipJohnBasile";
    repo = "vecstore";
    rev = "1868a6273174f58856af25ba6c45eb057d3bbfd0";
    hash = "sha256-sLhQjb3+7H7rgRoFNTRvTPtRaiDfJq8IqUbdwOu1g74=";
  };

  cargoHash = "sha256-zcqmVMC8xCftzDegDyJAu7xVeMjiZImBg7A3hXHMveU=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildFeatures = [ "server" ];

  cargoBuildFlags = [
    "--bin"
    "vecstore-server"
  ];

  # VecStore's release profile uses panic=abort, while Rust's test harness
  # requires unwind. Source tests run in the VecStore CI.
  doCheck = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Embeddable vector database with HNSW search and RAG tooling";
    homepage = "https://github.com/PhilipJohnBasile/vecstore";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.philipjohnbasile ];
    mainProgram = "vecstore-server";
    platforms = lib.platforms.unix;
  };
})
