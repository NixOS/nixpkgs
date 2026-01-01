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
<<<<<<< HEAD
  version = "0.5.0";
=======
  version = "0.4.8";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "veilid";
    repo = "veilid";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cdFC5KgdLxykXtB2YG/HKJCrEBnw1lYJ3IJkRwMC49s=";
  };

  cargoHash = "sha256-TtGXCxEEb8PngN3tzybY5P0LgeAMQoxvUp1qSLfj830=";
=======
    hash = "sha256-ZhF9dMYrd+nui/tw1SuL0i6zB/niBfsd40SQzRgGF6Q=";
  };

  cargoHash = "sha256-Q4M6cb9xYxeH4O7YL2K8olJ9w8Iq34hYpuJEGGhVN+Y=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "Open-source, peer-to-peer, mobile-first, networked application framework";
    mainProgram = "veilid-server";
    homepage = "https://veilid.com";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Open-source, peer-to-peer, mobile-first, networked application framework";
    mainProgram = "veilid-server";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bbigras
      qbit
    ];
  };
}
