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

buildGoModule (finalAttrs: {
  pname = "yubikey-touch-detector";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "max-baz";
    repo = "yubikey-touch-detector";
    tag = finalAttrs.version;
    hash = "sha256-GaahrYx5ySUIAM073JknQGPwC2pw2VXj3D25sEZANJk=";
  };
  vendorHash = "sha256-Uvybz2i2i/EWJvmvlb4VcJo/2SNaDAuj8t997sxlvtY=";

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
    homepage = "https://github.com/max-baz/yubikey-touch-detector";
    maintainers = with lib.maintainers; [ sumnerevans ];
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    mainProgram = "yubikey-touch-detector";
  };
})
