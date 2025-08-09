{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  protobuf,
  pkg-config,
  openssl,
}:
let
  pname = "teller";
  version = "2.0.7";
  date = "2024-05-19";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "tellerops";
    repo = "teller";
    rev = "v${version}";
    hash = "sha256-CI74nMMTIPwjJfy7ASR19V6EbYZ62NoAOxlP3Xt2BuI=";
  };

  cargoHash = "sha256-PSa4EEDEFdFpfYPG5M5wMwfq3WSqMw5d8a+mKgBzCFw=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/teller --version 2>&1 | grep ${version};
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/tellerops/teller/";
    description = "Cloud native secrets management for developers";
    mainProgram = "teller";
    license = licenses.asl20;
    maintainers = with maintainers; [
      cameronraysmith
      wahtique
    ];
  };
}
