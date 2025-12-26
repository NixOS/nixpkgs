{
  lib,
  fetchFromGitLab,
  rustPlatform,
  protobuf,
  capnproto,
  cmake,
  testers,
  veilid,
  gitUpdater,
}:

rustPlatform.buildRustPackage rec {
  pname = "veilid";
  version = "0.5.0";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = "veilid";
    rev = "v${version}";
    hash = "sha256-cdFC5KgdLxykXtB2YG/HKJCrEBnw1lYJ3IJkRwMC49s=";
  };

  cargoHash = "sha256-TtGXCxEEb8PngN3tzybY5P0LgeAMQoxvUp1qSLfj830=";

  nativeBuildInputs = [
    capnproto
    cmake
    protobuf
  ];

  cargoBuildFlags = [
    "--workspace"
  ];

  RUSTFLAGS = "--cfg tokio_unstable";

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
}
