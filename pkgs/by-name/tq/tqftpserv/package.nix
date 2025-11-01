{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  qrtr,
  systemd,
  zstd,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "tqftpserv";
  # Use unstable for fixed systemd service
  # with removed qrtr-ns dependency.
  version = "1.1-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "tqftpserv";
    rev = "408ca1ed5e4e0a9ac3650b13d3f3c60079b3e2a3";
    hash = "sha256-IlM/HVdo/7cA9NnJrCW/B0yKks5jWYqxRyy3ay4wDr8=";
  };

  nativeBuildInputs = [ meson ];

  buildInputs = [
    qrtr
    ninja
    pkg-config
    systemd
    zstd
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Trivial File Transfer Protocol server over AF_QIPCRTR";
    homepage = "https://github.com/linux-msm/tqftpserv";
    platforms = lib.platforms.linux;
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "tqftpserv";
  };
})
