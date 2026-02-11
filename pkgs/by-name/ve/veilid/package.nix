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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "veilid";
  version = "0.5.2";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = "veilid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-BND2Io3V5GtSqh9cTJ9SJ4jgfv6TZQGpYebO4f2YdMA=";
  };

  cargoHash = "sha256-glbrjue0d2bG1P3U5+nqfxvz2qlDd16bpvyQYpGuiyI=";

  nativeBuildInputs = [
    capnproto
    cmake
    protobuf
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
