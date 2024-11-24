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
  version = "7.11";

  src = fetchFromGitHub {
    repo = "telegram-bot-api";
    owner = "tdlib";
    rev = "6d1b62b51bdc543c10f854aae751e160e5b7b9c5";
    hash = "sha256-FLHAv9CQ90Jd2DnzQSRl5wHW6hnWUCz0Ap65Vjkgj0s=";
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
