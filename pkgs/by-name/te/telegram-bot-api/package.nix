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
  version = "9.2";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "telegram-bot-api";
    # https://github.com/tdlib/telegram-bot-api/issues/783
    rev = "3b6a0b769c4a7fbe064087a4ad9fe6b1dbda498f";
    hash = "sha256-EpDO1ulIT/RIUjc06BtGRpqdQIMpma5+DRy7i8YVhiU=";
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
  versionCheckProgramArg = "--version";

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
