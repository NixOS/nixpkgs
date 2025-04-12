{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gperf,
  openssl,
  zlib,
}:

stdenv.mkDerivation {
  pname = "telegram-bot-api";
  version = "8.0";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "telegram-bot-api";
    rev = "53e15345b04fcea73b415897f10d7543005044ce";
    hash = "sha256-OnYoJM2f9+/W4m1Ew9nDQQ/Mk0NnGr1dL5jCvLAXc1c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    gperf
  ];
  buildInputs = [
    openssl
    zlib
  ];

  meta = {
    description = "Telegram Bot API server";
    homepage = "https://github.com/tdlib/telegram-bot-api";
    license = lib.licenses.boost;
    maintainers = with lib.maintainers; [
      Anillc
      Forden
      nartsiss
    ];
    platforms = lib.platforms.all;
    mainProgram = "telegram-bot-api";
  };
}
