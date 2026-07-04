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
  version = "0.5.5";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = "veilid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-14jRIs2iE5JH1ZmC/1DGcg6cejsnmhUTkquXNmOEuQA=";
  };

  cargoHash = "sha256-xuIw/RRKydanStS7dw1jK96bgEH0U5TDbayaBZq/OCg=";

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
