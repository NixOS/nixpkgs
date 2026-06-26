{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gperf,
  openssl,
  zlib,
  versionCheckHook,
}:

stdenv.mkDerivation {
  pname = "telegram-bot-api";
  version = "10.1";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "telegram-bot-api";
    # https://github.com/tdlib/telegram-bot-api/issues/783
    rev = "0a9e5696ba149c99bedf972f040d2e28776a8a4f";
    hash = "sha256-F3TYYB5sI8nadiHUaxW5BOC1XMnEfsrZQX2dLJXA5Mg=";
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

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

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
