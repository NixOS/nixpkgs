{
  lib,
  libnotify,
  gpgme,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  scdoc,
}:

buildGoModule rec {
  pname = "yubikey-touch-detector";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "yubikey-touch-detector";
    tag = version;
    hash = "sha256-aHR/y8rAKS+dMvRdB3oAmOiI7hTA6qlF4Z05OjwYOO4=";
  };
  vendorHash = "sha256-oHEcpu3QvcVC/YCtGtP7nNT9++BSU8BPT5pf8NdLrOo=";

  nativeBuildInputs = [
    pkg-config
    scdoc
    installShellFiles
  ];

  buildInputs = [
    libnotify
    gpgme
  ];

  postInstall = ''
    install -Dm444 -t $out/share/doc/yubikey-touch-detector *.{md,example}

    install -Dm444 -t $out/share/licenses/yubikey-touch-detector LICENSE

    install -Dm444 -t $out/share/icons/hicolor/128x128/apps yubikey-touch-detector.png

    install -Dm444 -t $out/lib/systemd/user *.{service,socket}

    substituteInPlace $out/lib/systemd/user/*.service \
      --replace /usr/bin/yubikey-touch-detector "$out/bin/yubikey-touch-detector"

    scdoc < yubikey-touch-detector.1.scd > yubikey-touch-detector.1
    installManPage yubikey-touch-detector.1
  '';

  meta = {
    description = "Tool to detect when your YubiKey is waiting for a touch";
    homepage = "https://github.com/maximbaz/yubikey-touch-detector";
    maintainers = with lib.maintainers; [ sumnerevans ];
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    mainProgram = "yubikey-touch-detector";
  };
}
