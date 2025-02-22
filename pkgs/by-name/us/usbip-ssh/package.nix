{
  stdenv,
  lib,
  fetchFromGitHub,
  perl,
  openssh,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "usbip-ssh";
  version = "0-unstable-2024-10-09";

  src = fetchFromGitHub {
    owner = "turistu";
    repo = "usbip-ssh";
    rev = "1b38f2d7854048bf6129ffe992f3c9caa630e377";
    hash = "sha256-3kGGMlIMTXnBVLgsZijc0yLbyaZZSDf7lr46mg0viWw=";
  };

  buildInputs = [
    perl
    openssh
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 usbip-ssh -t $out/bin
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/turistu/usbip-ssh";
    description = "Import usb devices from another linux machine with ssh's connection forwarding mechanism";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kagehisa ];
    mainProgram = "usbip-ssh";
    platforms = lib.platforms.linux;
  };
})
