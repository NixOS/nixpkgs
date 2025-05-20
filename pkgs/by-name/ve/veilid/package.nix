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
  version = "0.4.6";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bKll7VB6LjkmmhN5lmjcSeP2zZbyWnl4XiZbZe3tKgg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-505gf4P/Hlo8KFynhAQdBagzEqGXhydhTTknat/jWmk=";

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

  meta = with lib; {
    description = "Open-source, peer-to-peer, mobile-first, networked application framework";
    mainProgram = "veilid-server";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      bbigras
      qbit
    ];
  };
}
