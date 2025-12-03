{
  stdenv,
  lib,
  fetchFromGitHub,
  qrtr,
  meson,
  zstd,
  pkg-config,
  systemd,
  ninja,
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

  buildInputs = [
    qrtr
    zstd
    systemd
  ];

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  postPatch = ''
    substituteInPlace translate.c --replace-fail '/lib/firmware/' '/run/current-system/sw/share/uncompressed-firmware'
  '';

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "Trivial File Transfer Protocol server over AF_QIPCRTR";
    homepage = "https://github.com/andersson/tqftpserv";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
    mainProgram = "tqftpserv";
  };
})
