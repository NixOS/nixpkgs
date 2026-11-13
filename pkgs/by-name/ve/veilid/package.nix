{
  lib,
  fetchFromGitLab,
  rustPlatform,
  protobuf,
  capnproto,
  cmake,
  sqlite,
  testers,
  veilid,
  gitUpdater,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "veilid";
  version = "0.5.8";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = "veilid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Z2H0bXjAZex0OKI0QN+f/8vqoXLeLt0bh8/Ss6MFs08=";
  };

  cargoHash = "sha256-AHWqH9Zb7bGJrHgI0HPf7HXNqCtuAYXs6+cNhL5bnWM=";

  nativeBuildInputs = [
    capnproto
    cmake
    protobuf
  ];

  buildInputs = [
    sqlite
  ];

  cargoBuildFlags = [
    "--workspace"
  ];

  env.RUSTFLAGS = "--cfg tokio_unstable";

  doCheck = false;

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests = {
      veilid-version = testers.testVersion {
        package = veilid;
      };
    };
  };

  meta = {
    description = "Open-source, peer-to-peer, mobile-first, networked application framework";
    mainProgram = "veilid-server";
    homepage = "https://veilid.com";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      bbigras
      qbit
    ];
  };
})
