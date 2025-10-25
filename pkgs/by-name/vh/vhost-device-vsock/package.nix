{
  lib,
  fetchFromGitHub,
  rustPlatform,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vhost-device-vsock";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "rust-vmm";
    repo = "vhost-device";
    tag = "vhost-device-vsock-v${finalAttrs.version}";
    hash = "sha256-g+u6WBJtizIgQwC0kkWdAcTiYCM1zMI4YBLVRU4MOrs=";
  };

  outputs = [
    "out"
    "man"
  ];

  cargoBuildFlags = "-p vhost-device-vsock";
  cargoTestFlags = "-p vhost-device-vsock";
  cargoHash = "sha256-mtORRCY/TNeIEgRCQ1ZbjpsykteRm2FHRveKaQxD/Pw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installManPage vhost-device-vsock/*.1
  '';

  meta = {
    homepage = "https://github.com/rust-vmm/vhost-device/blob/main/vhost-device-vsock/README.md";
    maintainers = with lib.maintainers; [ ma27 ];
    license = with lib.licenses; [
      asl20
      bsd3
    ];
    platforms = lib.platforms.linux;
  };
})
