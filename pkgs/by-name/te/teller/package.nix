{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  protobuf,
  stdenv,
  darwin,
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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CI74nMMTIPwjJfy7ASR19V6EbYZ62NoAOxlP3Xt2BuI=";
  };

  cargoHash = "sha256-iqZX+9l3TWrFuaQreNz4RrCgPQCyKJt6RJ1UeKYaNRs=";

  nativeBuildInputs = [
    protobuf
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.apple_sdk.frameworks.SystemConfiguration ];

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
