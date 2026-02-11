{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  libnotify,
  pcsclite,
  pkg-config,
}:

buildGoModule (finalAttrs: {
  pname = "yubikey-agent";

  version = "0.1.6";
  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "yubikey-agent";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-Knk1ipBOzjmjrS2OFUMuxi1TkyDcSYlVKezDWT//ERY=";
  };

  buildInputs = lib.optional stdenv.hostPlatform.isLinux (lib.getDev pcsclite);

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  postPatch = lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace main.go --replace 'notify-send' ${libnotify}/bin/notify-send
  '';

  vendorHash = "sha256-+IRPs3wm3EvIgfQRpzcVpo2JBaFQlyY/RI1G7XfVS84=";

  doCheck = false;

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/systemd/user
    substitute contrib/systemd/user/yubikey-agent.service $out/lib/systemd/user/yubikey-agent.service \
      --replace 'ExecStart=yubikey-agent' "ExecStart=$out/bin/yubikey-agent"
  '';

  meta = {
    description = "Seamless ssh-agent for YubiKeys";
    mainProgram = "yubikey-agent";
    license = lib.licenses.bsd3;
    homepage = "https://filippo.io/yubikey-agent";
    maintainers = with lib.maintainers; [
      philandstuff
      rawkode
    ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
  };
})
