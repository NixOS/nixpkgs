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
<<<<<<< HEAD
  # Use unstable for fixed systemd service
  # with removed qrtr-ns dependency.
  version = "1.1-unstable-2025-08-01";
=======
  version = "1.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "linux-msm";
    repo = "tqftpserv";
<<<<<<< HEAD
    rev = "408ca1ed5e4e0a9ac3650b13d3f3c60079b3e2a3";
    hash = "sha256-IlM/HVdo/7cA9NnJrCW/B0yKks5jWYqxRyy3ay4wDr8=";
=======
    tag = "v${finalAttrs.version}";
    hash = "sha256-Djw2rx1FXYYPXs6Htq7jWcgeXFvfCUoeidKtYUvTqZU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    maintainers = with lib.maintainers; [ matthewcroughan ];
    description = "Trivial File Transfer Protocol server over AF_QIPCRTR";
    homepage = "https://github.com/andersson/tqftpserv";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.aarch64;
    mainProgram = "tqftpserv";
=======
  meta = with lib; {
    maintainers = with maintainers; [ matthewcroughan ];
    description = "Trivial File Transfer Protocol server over AF_QIPCRTR";
    homepage = "https://github.com/andersson/tqftpserv";
    license = licenses.bsd3;
    platforms = platforms.aarch64;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
