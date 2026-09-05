{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  perl,
  curl,
  zlib,
  bzip2,
  xz,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "termrec";
  version = "0.19-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "kilobyte";
    repo = "termrec";
    rev = "dc3526e87655b5dc1d1174b0e1a3c0f38efa2b99";
    hash = "sha256-gBomLYUeqnTbYjweOIUKSSxCUuXNGcpTBGwqlc6nqg8=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    perl
  ];

  buildInputs = [
    curl
    zlib
    bzip2
    xz
    zstd
  ];

  meta = {
    description = "TTY recorder and player";
    homepage = "https://angband.pl/termrec.html";
    downloadPage = "https://github.com/kilobyte/termrec";
    mainProgram = "termrec";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ castorNova2 ];
  };
})
