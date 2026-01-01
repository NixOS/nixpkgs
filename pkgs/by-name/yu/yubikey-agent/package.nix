{
  stdenv,
  lib,
  fetchFromGitHub,
  buildGoModule,
  libnotify,
  pcsclite,
  pkg-config,
}:

buildGoModule rec {
  pname = "yubikey-agent";

  version = "0.1.6";
  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "yubikey-agent";
    rev = "v${version}";
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
    "-X main.Version=${version}"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/lib/systemd/user
    substitute contrib/systemd/user/yubikey-agent.service $out/lib/systemd/user/yubikey-agent.service \
      --replace 'ExecStart=yubikey-agent' "ExecStart=$out/bin/yubikey-agent"
  '';

<<<<<<< HEAD
  meta = {
    description = "Seamless ssh-agent for YubiKeys";
    mainProgram = "yubikey-agent";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Seamless ssh-agent for YubiKeys";
    mainProgram = "yubikey-agent";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://filippo.io/yubikey-agent";
    maintainers = with lib.maintainers; [
      philandstuff
      rawkode
    ];
<<<<<<< HEAD
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
=======
    platforms = platforms.darwin ++ platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
