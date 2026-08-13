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
  version = "10.2";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "telegram-bot-api";
    # https://github.com/tdlib/telegram-bot-api/issues/783
    rev = "adfd7f6a8e990272851777eeb3ae0def4216f161";
    hash = "sha256-sICBisUDMirUOMN5ORQ2B9Wo8KC91hIn1sHyt2xClJ0=";
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
