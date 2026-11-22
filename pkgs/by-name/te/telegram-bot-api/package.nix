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
  version = "10.3";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "telegram-bot-api";
    # https://github.com/tdlib/telegram-bot-api/issues/783
    rev = "e3e9dd8e5b3d7ab8537cd5a10dc31d5ffa8f82d1";
    hash = "sha256-I3pCoAUgB2ilDLm4jRgIq32lyvAfvsfyhcEKEx7+6iQ";
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
