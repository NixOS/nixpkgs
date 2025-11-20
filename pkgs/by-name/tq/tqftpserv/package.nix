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
  version = "1.1";

  buildInputs = [
    qrtr
    zstd
    systemd
  ];

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "tqftpserv";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Djw2rx1FXYYPXs6Htq7jWcgeXFvfCUoeidKtYUvTqZU=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
  ];

  patchPhase = ''
    substituteInPlace translate.c --replace-fail '/lib/firmware/' '/run/current-system/sw/share/uncompressed-firmware'
  '';

  installFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "Trivial File Transfer Protocol server over AF_QIPCRTR";
    homepage = "https://github.com/andersson/tqftpserv";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
  };
})
