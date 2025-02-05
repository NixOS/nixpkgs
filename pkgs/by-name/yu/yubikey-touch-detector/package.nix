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
  version = "1.12.5";

  src = fetchFromGitHub {
    owner = "maximbaz";
    repo = "yubikey-touch-detector";
    rev = version;
    hash = "sha256-eNRwDGTNxBtDepQvf2TXCH/5fb4kRYBn80tzvI4fzME=";
  };
  vendorHash = "sha256-x8Fmhsk6MtgAtLxgH/V3KusM0BXAOaSU+2HULR5boJQ=";

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
    install -Dm444 -t $out/share/doc/${pname} *.{md,example}

    install -Dm444 -t $out/share/licenses/${pname} LICENSE

    install -Dm444 -t $out/share/icons/hicolor/128x128/apps yubikey-touch-detector.png

    install -Dm444 -t $out/lib/systemd/user *.{service,socket}

    substituteInPlace $out/lib/systemd/user/*.service \
      --replace /usr/bin/yubikey-touch-detector "$out/bin/yubikey-touch-detector"

    scdoc < yubikey-touch-detector.1.scd > yubikey-touch-detector.1
    installManPage yubikey-touch-detector.1
  '';

  meta = with lib; {
    description = "Tool to detect when your YubiKey is waiting for a touch";
    homepage = "https://github.com/maximbaz/yubikey-touch-detector";
    maintainers = with maintainers; [ sumnerevans ];
    license = licenses.isc;
    platforms = platforms.linux;
    mainProgram = "yubikey-touch-detector";
  };
}
